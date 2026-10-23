{
  lix,
  paths,
  ...
}: let
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.filesystem.access) readFile;
  inherit (lix.filesystem.construction) concat;
  inherit (lix.modules.construction) mkOverride;
  inherit (lix.strings.construction) fromJSON;
  inherit (lix.types.predicates) isList;

  baseline = 1500; #? mkDefault is 1000

  learn = name: let
    captured = fromJSON (
      readFile (concat {
        root = paths.store.cfg.default;
        stem = ["vscode" "${name}.jsonc"];
      })
    );
  in
    if isList captured
    then captured
    else mapAttrs (_: mkOverride baseline) captured;
in {
  userSettings = learn "settings";
  keybindings = learn "keybindings";
}
