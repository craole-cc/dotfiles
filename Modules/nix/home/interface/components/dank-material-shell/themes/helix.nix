{
  config,
  inputs,
  lix,
  pkgs,
}: let
  inherit (inputs.home-manager.lib.hm.dag) entryAfter;
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.strings.transformation) escapeShellArg;
  inherit (pkgs) writeText;

  configHome = config.xdg.configHome;
  themeDirectory = concat {
    root = configHome;
    stem = ["helix" "themes"];
  };
  themePath = concat {
    root = themeDirectory;
    stem = ["base16_transparent.toml"];
  };
  themeTemplate = ./helix.toml;
  templateConfig = writeText "helix-matugen-template.toml" ''
    [templates.dms_helix]
    input_path = '${themeTemplate}'
    output_path = '${themePath}'
  '';
  activation = entryAfter ["writeBoundary"] ''
    mkdir -p ${escapeShellArg themeDirectory}
  '';
in {
  configFile."matugen/dms/configs/helix-matugen-theme.toml".source = templateConfig;
  inherit activation;
}
