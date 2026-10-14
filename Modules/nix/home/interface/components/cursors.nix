{
  lix,
  pkgs,
  style,
  ...
}: let
  inherit (lix.lists.predicates) isIn;
  inherit (lix.options.construction) mkOption;
  inherit (lix.styles.cursors) mkOne;
  inherit (lix.styles.cursors.types.polarity) home;
  inherit (lix.types.combinators) attrsOf;

  resolveCursor = polarity: requested: let
    size =
      if polarity == "dark"
      then 32
      else 24;
  in
    if isIn requested ["material-cursors" "material"]
    then {
      name = "material_${polarity}_cursors";
      package = pkgs.material-cursors;
      inherit size;
    }
    else let
      resolved =
        mkOne ({
            inherit pkgs polarity size;
            cursor = requested;
          }
          // {
            accent =
              if isIn requested ["catppuccin-cursors" "catppuccin"]
              then "mauve"
              else null;
          });
    in {
      inherit (resolved) name package size;
    };
in {
  options.themes.cursors = mkOption {
    type = attrsOf home;
    default = {};
    description = "Resolved cursor themes for each appearance mode";
  };

  config.themes.cursors = {
    dark = resolveCursor "dark" style.cursors.dark;
    light = resolveCursor "light" style.cursors.light;
  };
}
