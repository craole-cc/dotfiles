{
  lix,
  cfg,
  ...
} @ args: let
  inherit (lix.options.construction) mkTrue mkFalse;
  inherit (lix.attrsets.construction) listToAttrs;
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.filesystem.importers) importAllPaths;
  inherit (lix.filesystem.traversal) importJSON';
  inherit (lix.modules.construction) mkOverride;
  inherit (lix.modules.construction) mkMerge;
  inherit (lix.modules.evaluation) evalModules;
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.combinators) listOf;
  inherit (lix.types.primitives) package;
  inherit (lix.lists.transformation) filter;
  inherit (lix.types.predicates) isList;

  baseline = 1500; #? mkDefault is 1000

  learn = name: let
    data = importJSON' {
      root = args.paths.store.cfg.default;
      stem = ["vscode" "${name}.json"];
    };
  in
    if isList data
    then mkOverride baseline data
    else mapAttrs (_: mkOverride baseline) data;

  load = path:
    import path (
      args
      // {
        inherit (lix.modules.construction) mkDefault mkMerge;
        inherit (lix.lists.transformation) flatten;
        inherit (lix.applications.editors) mkVSCodeFeature mkVSCodeSubFeature;
      }
    );

  module = let
    imports = map load (importAllPaths ./.);
  in {
    options = listToAttrs (
      map (module: {
        inherit (module) name;
        value = with module;
          if default
          then mkTrue description
          else mkFalse description;
      })
      (filter (module: module ? feature) imports)
    );

    output = map (setting:
      {
        extensions = [];
        keybindings = [];
        userSettings = {};
      }
      // (
        if setting ? feature
        then (with setting; feature cfg.features.${name})
        else setting
      ))
    imports;
  };

  profile = let
    options = {
      userSettings = mkOption {
        inherit (args.json) type;
        default = {};
      };
      keybindings = mkOption {
        type = listOf args.json.type;
        default = [];
      };
      extensions = mkOption {
        type = listOf package;
        default = [];
      };
    };
    config = mkMerge (module.output
      ++ [
        {
          userSettings = learn "settings";
          keybindings = learn "keybindings";
        }
      ]);
    modules = evalModules {modules = [{inherit options config;}];};
    output = modules.config;
  in {inherit options config modules output;};
in {
  inherit (module) options;
  inherit (profile) output;
}
