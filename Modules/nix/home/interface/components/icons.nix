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
  inherit (lix.types.combinators) attrsOf;

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
  options.themes.icons = mkOption {
    type = attrsOf home;
    default = {};
    description = "Resolved icon themes for each appearance mode";
  };

  config.themes.icons = {
    dark = resolveIcon "dark" style.icons.dark;
    light = resolveIcon "light" style.icons.light;
  };
}
