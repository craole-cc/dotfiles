{lix, ...}: let
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.primitives) bool int str;
in {
  constraints = {
    desiredColor.enable = mkOption {
      type = bool;
      default = false;
      description = "Variety desired color enabled.";
    };
    desiredColor.value = mkOption {
      type = str;
      default = "160 160 160";
      description = "Variety desired color.";
    };
    minSize.enable = mkOption {
      type = bool;
      default = false;
      description = "Variety min size enabled.";
    };
    minSize.value = mkOption {
      type = int;
      default = 100;
      description = "Variety min size.";
    };
    landscape.enable = mkOption {
      type = bool;
      default = false;
      description = "Variety use landscape enabled.";
    };
    lightness.enable = mkOption {
      type = bool;
      default = false;
      description = "Variety lightness enabled.";
    };
    lightness.mode = mkOption {
      type = int;
      default = 0;
      description = "Variety lightness mode.";
    };
    minRating.enable = mkOption {
      type = bool;
      default = false;
      description = "Variety min rating enabled.";
    };
    minRating.value = mkOption {
      type = int;
      default = 4;
      description = "Variety min rating.";
    };
    nameRegex.enable = mkOption {
      type = bool;
      default = false;
      description = "Variety name regex enabled.";
    };
    nameRegex.value = mkOption {
      type = str;
      default = ".*";
      description = "Variety name regex.";
    };
  };
}
