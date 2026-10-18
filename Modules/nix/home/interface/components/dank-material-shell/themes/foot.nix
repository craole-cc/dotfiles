{
  config,
  lix,
  pkgs,
  user,
}:
let
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.strings.construction) concatStringsSep;
  inherit (pkgs) writeText;
  inherit (user.theme) modes;
  inherit (import ./palettes.nix { inherit lix; }) mkFootPalette;

  configHome = config.xdg.configHome or "${user.home}/.config";
  path = concat {
    root = configHome;
    stem = [
      "foot"
      "dank-colors.ini"
    ];
  };
  tag = "foot-matugen-theme";
  file = "${tag}.toml";
  target = concat {
    root = configHome;
    stem = [
      "matugen"
      "dms"
      "configs"
      file
    ];
  };
  source = writeText file ''
    [templates.${tag}]
    input_path = '${./foot.ini}'
    output_path = '${path}'
  '';
  fallback = writeText "foot-fallback-theme.ini" (
    concatStringsSep "\n" (
      map mkFootPalette (
        with modes;
        [
          dark
          light
        ]
      )
    )
  );
in
{
  configFile."${target}" = { inherit source; };
  matugenTemplateEnabled = false;
  inherit fallback path;
}
