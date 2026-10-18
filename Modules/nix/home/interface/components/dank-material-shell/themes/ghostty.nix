{
  config,
  pkgs,
  style,
}:
let
  inherit (config.xdg) configHome;
  inherit (pkgs) writeText;
in
{
  # DMS provides the `dankcolors` theme and generates its palette.
  matugenTemplateEnabled = true;
  opacity = {
    path = "${configHome}/ghostty/dotdots-opacity";
    fallback = writeText "dotdots-ghostty-opacity" ''
      background-opacity = ${toString style.opacity.terminal.dark}
    '';
  };
}
