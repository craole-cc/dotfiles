{
  lix,
  paths,
  ...
}: let
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.filesystem.traversal) importJSON';
  inherit (lix.modules.construction) mkOverride;
  inherit (lix.types.predicates) isList;

  baseline = 1500; #? mkDefault is 1000

  learn = name: let
    data = importJSON' {
      root = paths.store.cfg.default;
      stem = ["vscode" "${name}.json"];
    };
  in
    if isList data
    then data
    else mapAttrs (_: mkOverride baseline) data;
in {
  userSettings = learn "settings";
  keybindings = learn "keybindings";
}
