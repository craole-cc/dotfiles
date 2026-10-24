{
  lix,
  inputs,
  pkgs,
  cfg,
  ...
} @ args: let
  inherit (lix.applications.editors) mkVSCodeFeature mkVSCodeSubFeature normalizeSettings;
  inherit (lix.attrsets.access) attrNames;
  inherit (lix.attrsets.construction) listToAttrs;
  inherit (lix.attrsets.transformation) mapAttrs mapAttrsToList;
  inherit (lix.filesystem.access) readFileType;
  inherit (lix.filesystem.traversal) importAllNamed importJSON';
  inherit (lix.lists.aggregation) concatMap;
  inherit (lix.lists.construction) optional optionals;
  inherit (lix.lists.predicates) any;
  inherit (lix.lists.transformation) filter flatten uniqueStrings;
  inherit (lix.modules.construction) mkDefault mkMerge mkOverride;
  inherit (lix.modules.evaluation) evalModules;
  inherit (lix.options.construction) mkFalse mkOption mkTrue;
  inherit (lix.types.combinators) listOf;
  inherit (lix.types.predicates) isAttrs isList isPath;
  inherit (lix.types.primitives) package;

  baselineSettings = importJSON' {
    root = args.paths.store.cfg.default;
    stem = ["vscode" "settings.json"];
  };
  settingNames = attrNames baselineSettings;

  mkEntry = {
    stem ? "entry",
    name ? stem,
    description ? stem,
    enable ? true,
    extensions ? [],
    settings ? {},
    userSettings ? {},
    keybindings ? [],
  }:
    {inherit name description enable;}
    // mkVSCodeSubFeature {
      inherit enable extensions settings userSettings keybindings settingNames;
    };

  mkEntries = dir: let
    raw =
      (importAllNamed {
        inherit dir;
        args = removeAttrs args ["mkEntries" "mkEntry" "mkGroup"];
      }).value;
    #? `default.nix` supplies group metadata; never treat it as an entry.
    entries = removeAttrs raw ["default"];

    collect = stem: entry: let
      isConfig =
        isAttrs entry
        && any (name: entry ? ${name})
        ["enable" "extensions" "settings" "userSettings" "keybindings"];
    in
      optional isConfig (
        mkEntry ({inherit stem;} // entry)
      )
      ++ optionals (isAttrs entry && !isConfig) (
        flatten (mapAttrsToList collect entry)
      );
  in
    flatten (mapAttrsToList collect entries);

  mkGroupFor = path: {
    name ? null,
    description ? null,
    meta ? {},
    default ? true,
    entries ? null,
    features ? null,
  }: let
    resolved = {
      name =
        if name != null
        then name
        else meta.name or (throw "group at ${toString path} needs 'name' or 'meta.name'");

      description =
        if description != null
        then description
        else meta.description or resolved.name;

      dir =
        if readFileType path == "directory"
        then path
        else dirOf path;

      entries =
        if entries != null
        then
          if isPath entries
          then mkEntries entries
          else map mkEntry entries
        else if features != null
        then map mkEntry features
        else mkEntries resolved.dir;
    };
  in {
    inherit (resolved) name description;
    inherit default;
    feature = enable: let
      entries = filter (entry: entry.enable) resolved.entries;
    in
      mkVSCodeFeature {
        inherit enable pkgs inputs;
        extensions = uniqueStrings (
          concatMap (entry: entry.extensions or []) entries
        );
        userSettings = mkMerge (
          map normalizeSettings entries
        );
        keybindings =
          concatMap (entry: entry.keybindings or [])
          entries;
      };
  };

  load = path: let
    mkGroup = mkGroupFor path;
    loaded = import path (
      args
      // {inherit mkDefault mkMerge mkVSCodeFeature mkVSCodeSubFeature mkEntry mkGroup;}
    );
  in
    if loaded ? feature
    then loaded
    else mkGroup loaded;

  groups = map load [
    ./ai
    ./dev
    ./doc
    ./ui
  ];

  module = let
    options = listToAttrs (
      map (group: {
        inherit (group) name;
        value =
          if group.default
          then mkTrue group.description
          else mkFalse group.description;
      })
      groups
    );
    output = map (group: group.feature cfg.features.${group.name}) groups;
  in {inherit options output;};

  profile = let
    learn = name: let
      baseline = 1500;
      data =
        if name == "settings"
        then baselineSettings
        else
          importJSON' {
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
    config = mkMerge (
      module.output
      ++ [
        {
          userSettings = learn "settings";
          keybindings = learn "keybindings";
        }
      ]
    );
    modules = evalModules {modules = [{inherit options config;}];};
    output = modules.config;
  in {inherit options config modules output;};
in {
  inherit (module) options;
  inherit (profile) output;
}
