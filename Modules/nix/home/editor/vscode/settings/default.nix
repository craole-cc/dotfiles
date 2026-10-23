{
  lix,
  inputs,
  pkgs,
  cfg,
  ...
} @ args: let
  inherit (lix.applications.editors) mkVSCodeFeature mkVSCodeSubFeature;
  inherit (lix.attrsets.construction) listToAttrs;
  inherit (lix.attrsets.transformation) mapAttrs mapAttrsToList;
  inherit (lix.filesystem.traversal) importAllNamed importJSON';
  inherit (lix.lists.transformation) flatten sort;
  inherit (lix.modules.construction) mkDefault mkMerge mkOverride;
  inherit (lix.modules.evaluation) evalModules;
  inherit (lix.options.construction) mkFalse mkOption mkTrue;
  inherit (lix.trivial.predicates) lessThan;
  inherit (lix.types.combinators) listOf;
  inherit (lix.types.predicates) isAttrs isList isPath;
  inherit (lix.types.primitives) package;

  mkEntry = {
    stem ? "entry",
    name ? stem,
    description ? stem,
    enable ? true,
    extensions ? [],
    userSettings ? {},
    keybindings ? [],
  }:
    {inherit name description;}
    // mkVSCodeSubFeature {inherit enable extensions keybindings userSettings;};

  mkEntries = dir: let
    entries =
      (importAllNamed {
        inherit dir;
        args = removeAttrs args ["mkEntries" "mkEntry" "mkGroup"];
      }).value;
    collect = stem: entry:
      if isAttrs entry && (entry ? enable || entry ? extensions || entry ? userSettings || entry ? keybindings)
      then [(mkEntry ({inherit stem;} // entry))]
      else if isAttrs entry
      then flatten (mapAttrsToList collect entry)
      else [];
  in
    flatten (mapAttrsToList collect entries);

  mkGroupFor = path: {
    name,
    description,
    default ? true,
    entries ? null,
    features ? null,
  }: let
    groupEntries =
      if entries != null
      then
        if isPath entries
        then mkEntries entries
        else entries
      else if features != null
      then features
      else mkEntries (dirOf path);
  in {
    inherit name description default;
    feature = enable:
      mkVSCodeFeature {
        inherit enable pkgs inputs;
        extensions = sort lessThan (flatten (map (entry: entry.extensions or []) groupEntries));
        userSettings = mkMerge (map (entry: entry.userSettings or {}) groupEntries);
        keybindings = flatten (map (entry: entry.keybindings or []) groupEntries);
      };
  };

  load = path: let
    mkGroup = mkGroupFor path;
    loaded = import path (
      args
      // {
        inherit mkDefault mkMerge mkVSCodeFeature mkVSCodeSubFeature mkEntry mkGroup;
      }
    );
  in
    if loaded ? feature
    then loaded
    else mkGroup loaded;

  groups = map load [
    ./ai
    # ./ai-assistance.nix
    # ./colour-overrides.nix
    # ./debugging.nix
    # ./decorations.nix
    # ./editor.nix
    # ./environment-remote-sync.nix
    # ./files-explorer.nix
    # ./git.nix
    # ./global-application.nix
    # ./icons.nix
    # ./languages-a-z.nix
    # ./linting.nix
    # ./markdown-docs.nix
    # ./misc-extensions.nix
    # ./privacy-telemetry.nix
    # ./spelling-prose.nix
    # ./terminal.nix
    # ./themes.nix
    # ./typography.nix
    # ./workbench-layout.nix
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
