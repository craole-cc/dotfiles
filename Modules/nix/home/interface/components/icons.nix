{
  inputs,
  lix,
  pkgs,
  style,
  ...
}: let
  inherit (lix.lists.predicates) isIn;
  inherit (lix.styles.icons) mkOne;

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
    else
      mkOne {
        inherit pkgs polarity;
        icon = requested;
      };
in {
  _module.args.iconThemes = {
    dark = resolveIcon "dark" style.icons.dark;
    light = resolveIcon "light" style.icons.light;
  };
}
