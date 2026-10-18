{
  inputs,
  lix,
  pkgs,
  style,
  ...
}: let
  inherit (lix.lists.predicates) isIn;
  inherit (lix.options.construction) mkOption;
  inherit (lix.styles.icons) mkOne;
  inherit (lix.styles.icons.types.icon) home;

  buufIcons = pkgs.stdenvNoCC.mkDerivation {
    pname = "buuf-icons";
    version = "unstable-2026-10-12";
    src = inputs.buuf-icons;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/icons/Buuf"
      cp -R "$src"/. "$out/share/icons/Buuf/"
      runHook postInstall
    '';
  };

  resolveIcon = polarity: requested:
    if isIn requested ["buuf-nestort" "buufIcons" "buuf" "buuf-icons"]
    then {
      name = "Buuf";
      package = buufIcons;
    }
    else if isIn requested ["candy-icons" "candy"]
    then {
      name = "candy-icons";
      package = pkgs.candy-icons;
    }
    else
      mkOne {
        inherit pkgs polarity;
        icon = requested;
      };
in {
  options.themes.icons.dark = mkOption {
    type = home;
    default = resolveIcon "dark" style.icons.dark;
    description = "Icon theme definition for dark mode";
  };

  options.themes.icons.light = mkOption {
    type = home;
    default = resolveIcon "light" style.icons.light;
    description = "Icon theme definition for light mode";
  };
}
