{
  config,
  lix,
  inputs,
  pkgs,
  host,
  user,
  paths,
  entryAfter,
  ...
}: let
  inherit (lix.applications.generators) userApplicationConfig;
  inherit (lix.attrsets.access) attrNames;
  inherit (lix.attrsets.construction) genAttrs optionalAttrs;
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.attrsets.predicates) waylandEnabled;
  inherit (lix.modules.construction) mkConfig mkContext mkMerge mkDefault;
  inherit (lix.options.construction) mkEnable mkTrue;
  inherit (lix.schema.fonts) mkFonts;
  inherit (lix.sources.packages) pkgsFrom;

  context = mkContext {
    inherit config;
    dom = "editor";
    mod = "vscode";
    kind = "editor";
  };
  inherit (context) cfg;

  tools = pkgsFrom {
    inherit inputs pkgs;
    sources = {
      coreutils = null;
      dms = "dank-material-shell";
      vscode =
        if cfg.insiders
        then "vscode-insiders"
        else null;
    };
    # required = true;
  };

  bins = let
    mkCore = cmd: "${tools.coreutils.paths.binary}/${cmd}";
    coreutils = genAttrs ["chmod" "cp" "dirname" "install" "mkdir" "rm"] mkCore;
  in
    coreutils // {rmf = "${coreutils.rm} -rf";};

  args = {
    inherit bins cfg context entryAfter inputs lix mkDefault pkgs paths tools;
    fonts = mkFonts {inherit host user;};
    json = pkgs.formats.json {};
  };

  overrides = {
    settings = import ./settings args;
    keybindings = import ./control args;
    extensions = import ./extensions args;
  };
  inherit (import ./base (args // {inherit overrides;})) app profile dms;

  hasWayland = waylandEnabled {
    inherit config;
    interface = user.interface or {};
  };
  # TODO: We never user userApplicationConfig in our refactor so we don't have home,
  # Stable VS Code is deliberately mutable: install the FHS package, but do
  # not enable Home Manager's programs.vscode profile/file management. Insiders
  # is declarative for settings, keybindings, and its extension set.
  # resolved = userApplicationConfig {
  #   inherit context user pkgs;
  #   name = "vscode";
  #   category = "gui";
  #   customPackage = pkgs.vscode-fhs;
  #   resolutionHints = ["code" "vscode"];
  #   requiresWayland = true;
  #   extraPackages = [
  #     # vscode-insiders-nix derives from nixpkgs' stable VS Code package and keeps
  #     # its passthru metadata. Correct that metadata so desktop/icon/CLI identity is
  #     # Insiders rather than stable `code`.
  #     (inputs.vscode-insiders.packages.${system}.vscode-insiders.overrideAttrs (old: {
  #       passthru =
  #         (old.passthru or {})
  #         // {
  #           executableName = "code-insiders";
  #           longName = "Visual Studio Code - Insiders";
  #           iconName = "vscode-insiders";
  #         };
  #     }))
  #   ];
  #   debug = false;
  # };
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable {
        inherit context;
        condition = hasWayland;
      };
      insiders = mkTrue "Whether to use Visual Studio Code Insiders instead of the standard release.";
      withExtensions = features.options;
    };

    outputs = {
      home =
        resolved.home
        // {
          # file =
          #   app.extensionFiles
          #   // (let
          #     mk = stem:
          #       concat {
          #         inherit stem;
          #         root = app.extensionDirectory;
          #       };
          #   in {
          #     # A changing manifest invalidates VS Code's extension cache while
          #     # leaving the actual declarative extension directories as links.
          #     "${mk ".extensions-immutable.json"}" = {
          #       text = pkgs.vscode-utils.toExtensionJson profile.extensions;
          #       onChange = ''
          #         ${bins.rm} -f \
          #           "${mk "extensions.json"}" \
          #           "${mk ".init-default-profile-extensions"}"
          #       '';
          #     };
          #   });

          # activation =
          #   {
          #     # VS Code writes settings/keybindings itself. Materialise the
          #     # declarative profile as regular files on activation instead of
          #     # linking them into the Nix store, so runtime saves do not fail
          #     # EROFS. A future activation restores the declared baseline.
          #     materialiseVSCodeProfile = entryAfter ["linkGeneration"] ''
          #       materialise_json() {
          #         source="$1"
          #         target="$2"

          #         ${bins.mkdir} -p "$(${bins.dirname} "$target")"
          #         ${bins.rm} -f "$target"
          #         ${bins.install} -m 0644 "$source" "$target"
          #       }

          #       materialise_json \
          #         ${escapeShellArg app.settingsFile} \
          #         "$HOME/${app.userConfigDirectory}/settings.json"
          #       materialise_json \
          #         ${escapeShellArg app.keybindingsFile} \
          #         "$HOME/${app.userConfigDirectory}/keybindings.json"
          #     '';
          #   }
          #   // (dms.activation or {});
        };
    };
  }
