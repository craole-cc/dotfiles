{
  config,
  lix,
  pkgs,
  style,
  user,
}: let
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.strings.construction) concatStringsSep;
  inherit (lix.strings.transformation) escapeShellArg;
  inherit (pkgs) writeText;
  # TODO: Resolve in the schema so we get user > host > default
  inherit (user.theme) modes;
  inherit (import ./palettes.nix {inherit lix;}) mkFootPalette;

  configHome = config.xdg.configHome or "${user.home}/.config";
  apps = {
    # TODO: Select the DMS theme through the schema.
    catppuccin = let
      name = "catppuccin";
      theme = {
      };
      path = concat {
        root = configHome;
        stem = ["DankMaterialShell" "themes" "${name}.json"];
      };
      source = ./dms-catppuccin.json;
      pathStr = escapeShellArg path;
    in {inherit name path pathStr source;};

    foot = let
      name = "foot";
      path = concat {
        root = configHome;
        stem = [name "dank-colors.ini"];
      };
      theme = {
        mutagen = let
          tag = "${name}-matugen-theme";
          file = "${tag}.toml";
        in {
          name = tag;
          target = concat {
            root = configHome;
            stem = ["matugen" "dms" "configs" file];
          };
          source = writeText file ''
            [templates.${tag}]
            input_path = '${./${tag}.ini}'
            output_path = '${path}'
          '';
        };

        fallback = let
          tag = "${name}-fallback-theme";
          file = "${tag}.ini";
        in {
          name = tag;
          target = path;
          source = writeText file (concatStringsSep "\n" (
            map mkFootPalette (with modes; [dark light])
          ));
        };
      };
    in {inherit theme;};

    hermes = let
      name = "hermes";
      home = ".hermes";
    in {
      source = let
        tag = "${name}-matugen";
        template = ./${tag}.yaml;
      in
        writeText "dotdots-${tag}.toml" ''
          [templates.dotdots_${name}]
          input_path = '${template}'
          output_path = '${concat {
            root = config.home.homeDirectory;
            stem = [home "skins" "dms-wallpaper.yaml"];
          }}'
          # output_path = '${config.home.homeDirectory}/.hermes/skins/dms-wallpaper.yaml'
        '';
    };

    ghostty = {
      opacity = {
        fallback = writeText "dotdots-ghostty-opacity" ''
          background-opacity = ${toString style.opacity.terminal.dark}
        '';
      };
    };

    kitty = {
      opacity = {
        fallback = writeText "dotdots-kitty-opacity.conf" ''
          background_opacity ${toString style.opacity.terminal.dark}
        '';
      };
    };
  };
in
  apps
