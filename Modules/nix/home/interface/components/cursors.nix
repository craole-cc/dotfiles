{
  lix,
  pkgs,
  style,
  ...
}: let
  inherit (lix.lists.predicates) isIn;
  inherit (lix.styles.cursors) mkOne;

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
    else if isIn requested ["catppuccin-cursors" "catppuccin"]
    then
      mkOne {
        inherit pkgs polarity size;
        cursor = requested;
        accent = "mauve";
      }
    else
      mkOne {
        inherit pkgs polarity size;
        cursor = requested;
      };
in {
  _module.args.cursorThemes = {
    dark = resolveCursor "dark" style.cursors.dark;
    light = resolveCursor "light" style.cursors.light;
  };
}
