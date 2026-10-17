{
  config,
  lib,
  lix,
  inputs,
  pkgs,
  user,
  ...
}: let
  inherit (lib.hm.dag) entryAfter;
  inherit (lix.applications.generators) userApplicationConfig;
  inherit (lix.attrsets.access) attrNames;
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.attrsets.predicates) waylandEnabled;
  inherit (lix.lists.aggregation) concatMap;
  inherit (lix.modules.construction) mkConfig mkContext mkMerge mkDefault;
  inherit (lix.modules.evaluation) evalModules;
  inherit (lix.options.construction) mkEnable mkOption;
  inherit (lix.types.combinators) listOf;
  inherit (lix.types.primitives) package;
  inherit (lix.strings.transformation) escapeShellArg;
  inherit (pkgs.stdenv.hostPlatform) system;

  context = mkContext {
    inherit config;
    dom = "editor";
    mod = "vscode";
    kind = "editor";
  };
  inherit (context) cfg;

  bins = let
    mkCore = cmd: "${pkgs.coreutils}/bin/${cmd}";
  in {
    chmod = mkCore "chmod";
    cp = mkCore "cp";
    dirname = mkCore "dirname";
    install = mkCore "install";
    mkdir = mkCore "mkdir";
    rm = mkCore "rm";
  };

  base = import ./base/default.nix {inherit lix mkDefault;};
  features = import ./features/default.nix {inherit lix inputs pkgs;};

  # Resolve the existing profile fragments through a small option module so
  # mkDefault/mkMerge semantics are preserved without making stable VS Code's
  # writable user configuration Home Manager-owned.
  jsonFormat = pkgs.formats.json {};
  profile =
    (evalModules {
      modules = [
        {
          options = {
            userSettings = mkOption {
              inherit (jsonFormat) type;
              default = {};
            };
            keybindings = mkOption {
              type = listOf jsonFormat.type;
              default = [];
            };
            extensions = mkOption {
              type = listOf package;
              default = [];
            };
          };
        }
        {
          config = mkMerge (
            [base]
            ++ (
              map
              (name: features.features.${name} cfg.withExtensions.${name})
              (attrNames features.options)
            )
          );
        }
      ];
    }).config;

  hasWayland = waylandEnabled {
    inherit config;
    interface = user.interface or {};
  };
  dmsEnabled = context.wantsDmsShell.condition;

  # DMS only discovers its VS Code integration by finding a writable
  # `danklinux.dms-theme-*` extension in the editor's normal extensions
  # directory. Keep this one extension mutable because Matugen rewrites its
  # theme JSON files whenever DMS colors change.
  dmsThemeSource = "${inputs.dank-material-shell.outPath}/quickshell/matugen/vsix-build";
  dmsThemeMeta = builtins.fromJSON (builtins.readFile "${dmsThemeSource}/package.json");
  dmsThemeDir = "danklinux.dms-theme-${dmsThemeMeta.version}";

  # Insiders remains declarative while using its normal mutable extensions
  # directory. Normal extensions are store-backed symlinks; only the DMS theme
  # directory is a writable runtime copy.
  extensionNames = extension:
    if extension ? vscodeExtUniqueId
    then [extension.vscodeExtUniqueId]
    else attrNames (builtins.readDir "${extension}/share/vscode/extensions");

  insidersExtensionFiles = builtins.listToAttrs (
    concatMap
    (extension:
      map
      (extensionName: {
        name = ".vscode-insiders/extensions/${extensionName}";
        value.source = "${extension}/share/vscode/extensions/${extensionName}";
      })
      (extensionNames extension))
    profile.extensions
  );

  insidersSettings =
    profile.userSettings
    // optionalAttrs dmsEnabled {
      # DMS rewrites the default theme in place to follow its own runtime mode.
      # Letting VS Code independently follow the desktop portal races that
      # mechanism and can make it select a light theme while DMS is dark.
      "window.autoDetectColorScheme" = false;
      "workbench.colorTheme" = "Dynamic Base16 DankShell";
    };

  insidersSettingsFile = jsonFormat.generate "vscode-insiders-settings.json" insidersSettings;
  insidersKeybindingsFile = jsonFormat.generate "vscode-insiders-keybindings.json" profile.keybindings;

  # Stable VS Code is deliberately mutable: install the FHS package, but do
  # not enable Home Manager's programs.vscode profile/file management. Insiders
  # is declarative for settings, keybindings, and its extension set.
  resolved = userApplicationConfig {
    inherit context user pkgs;
    name = "vscode";
    category = "gui";
    customPackage = pkgs.vscode-fhs;
    resolutionHints = ["code" "vscode"];
    requiresWayland = true;
    extraPackages = [
      # vscode-insiders-nix derives from nixpkgs' stable VS Code package and keeps
      # its passthru metadata. Correct that metadata so desktop/icon/CLI identity is
      # Insiders rather than stable `code`.
      inputs.vscode-insiders.packages.${system}.vscode-insiders.overrideAttrs
      (old: {
        passthru =
          (old.passthru or {})
          // {
            executableName = "code-insiders";
            longName = "Visual Studio Code - Insiders";
            iconName = "vscode-insiders";
          };
      })
    ];
    debug = false;
  };
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable {
        inherit context;
        condition = hasWayland;
      };
      withExtensions = features.options;
    };

    outputs = {
      home =
        resolved.home
        // {
          file =
            insidersExtensionFiles
            // {
              # A changing manifest invalidates VS Code's extension cache while
              # leaving the actual declarative extension directories as links.
              ".vscode-insiders/extensions/.extensions-immutable.json" = {
                text = pkgs.vscode-utils.toExtensionJson profile.extensions;
                onChange = ''
                  ${pkgs.coreutils}/bin/rm -f \
                    "$HOME/.vscode-insiders/extensions/extensions.json" \
                    "$HOME/.vscode-insiders/extensions/.init-default-profile-extensions"
                '';
              };
            };

          # Keep both activation entries under one attribute. A top-level `//`
          # between two `{ activation = ...; }` sets is shallow and previously
          # caused the DMS seed action to replace the profile materializer.
          activation =
            {
              # VS Code writes settings/keybindings itself. Materialise the
              # declarative profile as regular files on activation instead of
              # linking them into the Nix store, so runtime saves do not fail
              # EROFS. A future activation restores the declared baseline.
              materialiseVSCodeInsidersProfile = entryAfter ["linkGeneration"] ''
                materialise_json() {
                  source="$1"
                  target="$2"

                  ${bins.mkdir} -p "$(${bins.dirname} "$target")"
                  ${bins.rm} -f "$target"
                  ${bins.install} -m 0644 "$source" "$target"
                }

                materialise_json \
                  ${escapeShellArg insidersSettingsFile} \
                  "$HOME/.config/Code - Insiders/User/settings.json"
                materialise_json \
                  ${escapeShellArg insidersKeybindingsFile} \
                  "$HOME/.config/Code - Insiders/User/keybindings.json"
              '';
            }
            // optionalAttrs dmsEnabled {
              seedDmsVSCodeTheme = entryAfter ["linkGeneration"] ''
                source=${escapeShellArg dmsThemeSource}
                theme_dir=${escapeShellArg dmsThemeDir}

                seed_dms_theme() {
                  root="$1"
                  target="$root/$theme_dir"

                  ${bins.mkdir} -p "$root"

                  # Keep exactly the DMS extension that matches the pinned shell
                  # input. Other user-installed extensions are untouched.
                  for candidate in "$root"/danklinux.dms-theme-*; do
                    [ -e "$candidate" ] || [ -L "$candidate" ] || continue
                    [ "$candidate" = "$target" ] || ${bins.rm} -rf "$candidate"
                  done

                  # DMS must be able to rewrite themes/*.json, so never leave
                  # this extension as a Nix-store symlink.
                  if [ -L "$target" ] || [ ! -f "$target/package.json" ]; then
                    ${bins.rm} -rf "$target"
                    ${bins.cp} -RL "$source" "$target"
                  fi
                  ${bins.chmod} -R u+w "$target"
                }

                seed_dms_theme "$HOME/.vscode/extensions"
                seed_dms_theme "$HOME/.vscode-insiders/extensions"
              '';
            };
        };
    };
  }
