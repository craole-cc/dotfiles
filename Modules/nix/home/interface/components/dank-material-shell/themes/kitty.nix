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
  # Kitty loads DMS-generated dank-tabs.conf and dank-theme.conf when enabled.
  opacity = {
    path = "${configHome}/kitty/dotdots-opacity.conf";
    fallback = writeText "dotdots-kitty-opacity.conf" ''
      background_opacity ${toString style.opacity.terminal.dark}
    '';
  };
}
