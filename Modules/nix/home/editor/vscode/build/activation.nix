{
  entryAfter,
  bins,
  dms,
  lix,
  app,
  profile,
  pkgs,
  ...
}: let
  inherit (lix.strings.transformation) escapeShellArg;
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.attrsets.construction) optionalAttrs;

  extensions = let
    mk = stem:
      concat {
        inherit stem;
        root = app.directories.extension;
      };
  in {
    # A changing manifest invalidates VS Code's extension cache while
    # leaving the actual declarative extension directories as links.
    "${mk ".extensions-immutable.json"}" = {
      text = pkgs.vscode-utils.toExtensionJson profile.extensions;
      onChange = ''
        ${bins.rm} -f \
          "${mk "extensions.json"}" \
          "${mk ".init-default-profile-extensions"}"
      '';
    };
  };

  activation = let
    mk = stem:
      concat {
        inherit stem;
        root = app.directories.configuration;
      };
    for = type: escapeShellArg app.files.${type};
  in {
    # VS Code writes settings/keybindings itself. Materialise the
    # declarative profile as regular files on activation instead of
    # linking them into the Nix store, so runtime saves do not fail
    # EROFS. A future activation restores the declared baseline.
    materialiseVSCodeProfile = entryAfter ["linkGeneration"] ''
      materialise_json() {
        source="$1"
        target="$2"

        ${bins.mkdir} -p "$(${bins.dirname} "$target")"
        ${bins.rm} -f "$target"
        ${bins.install} -m 0644 "$source" "$target"
      }

      materialise_json ${for "settings"} "${mk "settings.json"}"
      materialise_json ${for "keybindings"} "${mk "keybindings.json"}"
    '';
  };

  theme = optionalAttrs dms.enabled {
    seedDmsVSCodeTheme = entryAfter ["linkGeneration"] ''
      source=${escapeShellArg dms.source}
      theme_version=$(${bins.jaq} -er '.version | strings | select(length > 0)' "$source/package.json")
      theme_dir="danklinux.dms-theme-$theme_version"

      seed_dms_theme() {
        root="$1"
        target="$root/$theme_dir"

        ${bins.mkdir} -p "$root"

        # Keep exactly the DMS extension that matches the pinned shell
        # input. Other user-installed extensions are untouched.
        for candidate in "$root"/danklinux.dms-theme-*; do
          [ -e "$candidate" ] || [ -L "$candidate" ] || continue
          [ "$candidate" = "$target" ] || ${bins.rmf} "$candidate"
        done

        # DMS must be able to rewrite themes/*.json, so never leave
        # this extension as a Nix-store symlink.
        if [ -L "$target" ] || [ ! -f "$target/package.json" ]; then
          ${bins.rmf} "$target"
          ${bins.cp} -RL "$source" "$target"
        fi
        ${bins.chmod} -R u+w "$target"
      }

      seed_dms_theme "${app.directories.extension}"
    '';
  };
in {
  file = app.files.extension // extensions;
  activation = activation // theme;
}
