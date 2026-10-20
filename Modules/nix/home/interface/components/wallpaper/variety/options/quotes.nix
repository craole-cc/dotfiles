{
  lix,
  paths,
  style,
  ...
}: let
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.primitives) bool int str;
in {
  quotes = {
    enable = mkOption {
      type = bool;
      default = false;
    };
    font = mkOption {
      type = str;
      default = "${style.fonts.serif} 30";
      description = "Font family and size used for wallpaper quotes.";
    };
    text.color = mkOption {
      type = str;
      default = "255 255 255";
      description = "Variety quotes text color.";
    };
    background.color = mkOption {
      type = str;
      default = "80 80 80";
      description = "Variety quotes bg color.";
    };
    background.opacity = mkOption {
      type = int;
      default = 55;
      description = "Variety quotes bg opacity.";
    };
    text.shadow = mkOption {
      type = bool;
      default = false;
      description = "Variety quotes text shadow.";
    };
    width = mkOption {
      type = int;
      default = 70;
      description = "Variety quotes width.";
    };
    position.horizontal = mkOption {
      type = int;
      default = 100;
      description = "Variety quotes hpos.";
    };
    position.vertical = mkOption {
      type = int;
      default = 40;
      description = "Variety quotes vpos.";
    };
    maxLength = mkOption {
      type = int;
      default = 250;
      description = "Variety quotes max length.";
    };
    disabledSources = mkOption {
      type = str;
      default = "Urban Dictionary";
      description = "Variety quotes disabled sources.";
    };
    tags = mkOption {
      type = str;
      default = "";
      description = "Variety quotes tags.";
    };
    authors = mkOption {
      type = str;
      default = "";
      description = "Variety quotes authors.";
    };
    change.enable = mkOption {
      type = bool;
      default = false;
      description = "Variety quotes change enabled.";
    };
    change.interval = mkOption {
      type = int;
      default = 300;
      description = "Variety quotes change interval.";
    };
    preferred.file = mkOption {
      type = str;
      default = paths.variety.files.quotes;
      description = "File for preferred quotes.";
    };
    preferred.format = mkOption {
      type = str;
      default = "fortune";
      description = "Format for preferred quotes.";
    };
  };
}
