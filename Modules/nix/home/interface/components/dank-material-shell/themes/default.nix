{
  config,
  inputs,
  lix,
  pkgs,
}: let
  inherit (lix.attrsets.access) getAttr;
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.lists.aggregation) concatMap;

  icons = import ./icons.nix {inherit config lix;};
  cursors = import ./cursors.nix {inherit config lix;};
  helix = import ./helix.nix {inherit config inputs lix pkgs;};
  mkThemeModals = {
    modes ? ["dark" "light"],
    types ? ["icons" "cursors"],
  }: let
    mk = mode: type: let
      selected = getAttr mode (getAttr type {inherit icons cursors;});
    in {"icons/${selected.theme}" = {inherit (selected) source;};};
  in
    concatMap (type: map (mode: mk mode type) modes) types;

  dataFile = mergeSafe (mkThemeModals {});
  resolved = {
    inherit (config.themes) cursors icons;
  };
in {
  inherit cursors dataFile helix icons resolved;
}
