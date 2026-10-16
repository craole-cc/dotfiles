pkgs: let
  inherit (pkgs) curl;
in {
  plugins = {
    wallpaperDiscovery.enable = true;
    wallpaperCarousel.enable = true;
    spotlightWallpapers.enable = true;
  };

  packages = [curl];
}
