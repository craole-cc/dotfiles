{
  lix,
  inputs,
  pkgs,
  cfg,
  ...
} @ args: let
  inherit (lix.applications.editors) mkVSCodeFeature mkVSCodeSubFeature normalizeSettings;
  inherit (lix.attrsets.access) attrNames;
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.attrsets.construction) listToAttrs;
  inherit (lix.attrsets.transformation) mapAttrs mapAttrsToList;
  inherit (lix.filesystem.access) readFileType;
  inherit (lix.filesystem.traversal) importAllNamed importJSON';
  inherit (lix.lists.aggregation) concatMap;
  inherit (lix.lists.construction) optional optionals;
  inherit (lix.lists.predicates) any elem;
  inherit (lix.lists.transformation) filter flatten uniqueStrings;
  inherit (lix.modules.construction) mkDefault mkMerge mkOverride;
  inherit (lix.modules.evaluation) evalModules;
  inherit (lix.options.construction) mkFalse mkOption mkTrue;
  inherit (lix.strings.predicates) hasInfix hasPrefix;
  inherit (lix.types.combinators) listOf;
  inherit (lix.types.predicates) isAttrs isList isPath;
  inherit (lix.types.primitives) package;

  baselineSettings = importJSON' {
    root = args.paths.store.cfg.default;
    stem = ["vscode" "settings.json"];
  };
  readEntries = dir:
    removeAttrs
    (importAllNamed {
      inherit dir;
      args = removeAttrs args ["mkEntries" "mkEntry" "mkGroup"];
    }).value ["default"];

  # Explicit dotted keys mark complete settings, including object values.
  # Share these boundaries so another entry can use the same setting nested.
  collectSettingNames = prefix: value:
    if !isAttrs value
    then []
    else if (value._type or null) == "vscode-setting"
    then [prefix]
    else if elem prefix (attrNames baselineSettings)
    then []
    else if value ? _type && value._type == "merge"
    then concatMap (collectSettingNames prefix) value.contents
    else if value ? _type && elem value._type ["if" "override" "order"]
    then collectSettingNames prefix value.content
    else
      concatMap (key: let
        name =
          if prefix == ""
          then key
          else "${prefix}.${key}";
      in
        if prefix == "" && hasPrefix "[" key
        then collectSettingNames "" value.${key}
        else if hasInfix "." key
        then [name]
        else collectSettingNames name value.${key}) (attrNames value);

  collectEntrySettingNames = tree:
    if !isAttrs tree
    then []
    else if tree ? settings || tree ? userSettings
    then
      collectSettingNames "" (tree.settings or {})
      ++ collectSettingNames "" (tree.userSettings or {})
    else concatMap (key: collectEntrySettingNames tree.${key}) (attrNames tree);

  groupPaths = [./ai ./app ./dev ./doc ./ui];
  settingNames = uniqueStrings (
    attrNames baselineSettings
    ++ concatMap (dir: collectEntrySettingNames (readEntries dir)) groupPaths
  );

  mkEntry = {
    stem ? "entry",
    name ? stem,
    description ? stem,
    enable ? true,
    extensions ? [],
    settings ? {},
    userSettings ? {},
    keybindings ? [],
    options ? {},
  }: let
    declaredSettings = normalizeSettings {inherit settings userSettings settingNames;};
  in
    {
      inherit name description enable;
      ownedSettings = attrNames declaredSettings;
      ownedKeybindings = keybindings;
      inherit options;
    }
    // mkVSCodeSubFeature {
      inherit enable extensions settings userSettings keybindings settingNames;
    };

  mkEntries = dir: let
    entries = readEntries dir;

    collect = stem: entry: let
      isConfig =
        isAttrs entry
        && any (name: entry ? ${name})
        ["enable" "extensions" "settings" "userSettings" "keybindings" "options"];
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
    options ? {},
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
    ownedSettings = concatMap (entry: entry.ownedSettings) resolved.entries;
    ownedKeybindings = concatMap (entry: entry.ownedKeybindings) resolved.entries;
    options = mergeSafe (map (entry: entry.options or {}) resolved.entries) options;
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

  groups = map load groupPaths;

  module = let
    featureOptions = mergeSafe (map (group: group.options or {}) groups);
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
  in {inherit options output featureOptions;};

  profile = let
    # Nix entries own their declarations even when disabled. The JSON files
    # supply only settings and bindings that have not moved to an entry yet.
    ownedSettings = uniqueStrings (concatMap (group: group.ownedSettings or []) groups);
    ownedKeybindings = concatMap (group: group.ownedKeybindings or []) groups;
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
      then mkOverride baseline (filter (binding: !(elem binding ownedKeybindings)) data)
      else mapAttrs (_: mkOverride baseline) (removeAttrs data ownedSettings);

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
      ++ optional (cfg.importJSON or false) {
        userSettings = learn "settings";
        keybindings = learn "keybindings";
      }
    );
    modules = evalModules {modules = [{inherit options config;}];};
    output = modules.config;
  in {inherit options config modules output;};
in {
  inherit (module) options featureOptions;
  inherit (profile) output;
}
