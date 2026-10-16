{
  config,
  pkgs,
}: let
  inherit (pkgs) clight;
  hyprland = config._.resolved.interface.managers.hyprland.explicit.enable or false;
in {
  plugins = {
    dankClight.enable = true;
    dankDesktopWeather.enable = true;
    dankHyprlandWindows.enable = hyprland;
    displaySettings.enable = hyprland;
    showDesktop.enable = hyprland;
    dmsScreenshot.enable = true;
  };

  packages = [clight];
}
