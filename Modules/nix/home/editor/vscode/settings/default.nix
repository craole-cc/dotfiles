{
  lix,
  inputs,
  pkgs,
  cfg,
  ...
} @ args: let
  inherit (lix.applications.editors) mkVSCodeFeature mkVSCodeSubFeature;
  inherit (lix.attrsets.construction) listToAttrs;
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.filesystem.importers) importAllPaths;
  inherit (lix.filesystem.traversal) importJSON';
  inherit (lix.lists.transformation) filter flatten sort;
  inherit (lix.modules.construction) mkDefault mkMerge mkOverride;
  inherit (lix.modules.evaluation) evalModules;
  inherit (lix.options.construction) mkFalse mkOption mkTrue;
  inherit (lix.trivial.predicates) lessThan;
  inherit (lix.types.combinators) listOf;
  inherit (lix.types.predicates) isList;
  inherit (lix.types.primitives) package;

  load = path:
    import path (
      args
      // {
        inherit mkDefault mkMerge flatten mkVSCodeFeature mkVSCodeSubFeature;

        mkEntry = {
          enable ? true,
          extensions ? [],
          userSettings ? {},
        }:
          mkVSCodeSubFeature {inherit enable extensions userSettings;};

        mkGroup = {
          name,
          description,
          default ? true,
          features ? [],
        }: {
          inherit name description default;
          feature = enable:
            mkVSCodeFeature {
              inherit enable pkgs inputs;
              #? Stable ordering keeps the generated extension set independent of feature declaration order.
              extensions = sort lessThan (
                flatten (map
                  (feature: feature.extensions)
                  features)
              );
              userSettings = mkMerge (
                map
                (feature: feature.userSettings or {})
                features
              );
              keybindings = flatten (
                map
                (feature: feature.keybindings or [])
                features
              );
            };
        };
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
    learn = name: let
      baseline = 1500; #? mkDefault is 1000
      data = importJSON' {
        root = args.paths.store.cfg.default;
        stem = ["vscode" "${name}.json"];
      };
    in
      if isList data
      then mkOverride baseline data
      else mapAttrs (_: mkOverride baseline) data;

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
