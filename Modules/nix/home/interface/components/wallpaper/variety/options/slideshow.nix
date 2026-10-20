{
  lix,
  paths,
  ...
}: let
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.combinators) either;
  inherit (lix.types.primitives) bool float str;
in {
  slideshow = {
    preferred.enable = mkOption {
      type = bool;
      default = true;
      description = "Whether to include preferred wallpapers in the slideshow.";
    };
    sources.enable = mkOption {
      type = bool;
      default = true;
      description = "Variety slideshow sources enabled.";
    };
    downloads.enable = mkOption {
      type = bool;
      default = false;
      description = "Variety slideshow downloads enabled.";
    };
    custom.enable = mkOption {
      type = bool;
      default = false;
      description = "Variety slideshow custom enabled.";
    };
    custom.folder = mkOption {
      type = str;
      default = paths.wallpapers.slideshow;
      description = "Variety slideshow custom folder.";
    };
    sortOrder = mkOption {
      type = str;
      default = "Random";
      description = "Variety slideshow sort order.";
    };
    monitor = mkOption {
      type = str;
      default = "All";
      description = "Variety slideshow monitor.";
    };
    mode = mkOption {
      type = str;
      default = "Fullscreen";
      description = "Variety slideshow mode.";
    };
    seconds = mkOption {
      type = either float str;
      default = 6.0;
      description = "Variety slideshow seconds.";
    };
    fade = mkOption {
      type = either float str;
      default = 0.4;
      description = "Variety slideshow fade.";
    };
    zoom = mkOption {
      type = either float str;
      default = 0.2;
      description = "Variety slideshow zoom.";
    };
    pan = mkOption {
      type = either float str;
      default = 0.05;
      description = "Variety slideshow pan.";
    };
  };
}
