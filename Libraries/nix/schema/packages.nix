{_, ...}: let
  inherit (_.attrsets.access) attrNames;
  inherit (_.attrsets.aggregation) recursiveUpdate;
  inherit (_.attrsets.construction) genAttrs optionalAttrs;
  inherit (_.attrsets.transformation) filterAttrs mapAttrs;
  inherit (_.lists.access) elemAt length;
  inherit (_.lists.aggregation) concatMap;
  inherit (_.lists.construction) toList;
  inherit (_.lists.predicates) all any elem;
  inherit (_.lists.selection) filter;
  inherit (_.lists.transformation) unique;
  inherit (_.types.predicates) isAttrs isList isString typeOf;

  roles = ["primary" "secondary" "tertiary"];
  protocols = ["wayland" "x11" "xorg"];

  # These existing host fields configure inputs or nixpkgs rather than selecting a group.
  policyFields = [
    "core"
    "home"
    "kernel"
    "allowUnfree"
    "allowBroken"
    "allowUnstable"
    "allowUnsupportedSystem"
    "unstable"
  ];

  strings = name: value: let
    entries = toList value;
  in
    if all isString entries
    then entries
    else throw "packages.${name}: expected a string or list of strings, got ${typeOf value}";

  # Keep the ordinary list separate from explicit priorities until all layers
  # have merged. A later list replaces that list without erasing role choices.
  # `list` is the staging representation; public groups resolve to plain lists.
  prepareGroup = name: value:
    if value == null
    then {list = [];}
    else if isString value || isList value
    then {list = strings name value;}
    else if isAttrs value
    then let
      unknown = filter (key: !elem key (roles ++ protocols ++ ["list"])) (attrNames value);
    in
      if unknown != []
      then throw "packages.${name}: unknown priority fields: ${toString unknown}"
      else
        mapAttrs (key: entry:
          if elem key protocols
          then prepareGroup "${name}.${key}" entry
          else if key == "list"
          then strings name entry
          else if entry == null || isString entry
          then entry
          else throw "packages.${name}.${key}: expected a string or null")
        value
    else throw "packages.${name}: expected a string, list or priority attrset, got ${typeOf value}";

  splitEditors = groups: let
    editor = groups.editor or null;
    hasPart = part:
      isAttrs editor && (editor ? ${part} || any (protocol: isAttrs (editor.${protocol} or null) && editor.${protocol} ? ${part}) protocols);
    nested = hasPart "tty" || hasPart "gui";
    part = name: let
      value = editor.${name} or {};
      base =
        if isAttrs value
        then value
        else {list = strings "editor.${name}" value;};
    in
      recursiveUpdate base (genAttrs
        (filter (protocol: isAttrs (editor.${protocol} or null) && editor.${protocol} ? ${name}) protocols)
        (protocol: editor.${protocol}.${name}));
  in
    (removeAttrs groups ["ai"])
    // optionalAttrs (groups ? ai) {ai-agent = groups.ai;}
    // optionalAttrs (groups ? ai-agent) {inherit (groups) ai-agent;}
    // optionalAttrs nested (
      optionalAttrs (hasPart "tty") {editor = part "tty";}
      // optionalAttrs (!(hasPart "tty")) {editor = {};}
      // optionalAttrs (hasPart "gui") {ide = part "gui";}
      // optionalAttrs (groups ? ide) {inherit (groups) ide;}
    );

  isUtilityFlags = value:
    isAttrs value && all (name: isAttrs value.${name} && value.${name} ? enable) (attrNames value);

  prepareGroups = {
    groups,
    legacy ? false,
  }: let
    stripLegacy = value:
      if isAttrs value
      then mapAttrs (_name: stripLegacy) (filterAttrs (name: _entry: elem name (roles ++ protocols ++ ["list"])) value)
      else value;
    # Legacy utility controls merge by key, including explicit false values.
    # Convert them only during resolution, after those controls have merged.
    selections = filterAttrs (name: value: !(legacy && name == "utilities" && isUtilityFlags value)) groups;
    prepared = mapAttrs (name: value:
      prepareGroup name (
        if legacy
        then stripLegacy value
        else value
      ))
    (splitEditors (removeAttrs selections policyFields));
  in
    if legacy
    then filterAttrs (_name: value: value != {}) prepared
    else prepared;

  declarations = record:
    recursiveUpdate
    (prepareGroups {
      groups = record.applications or {};
      legacy = true;
    })
    (prepareGroups {groups = record.packages or {};});

  /**
  Merge sparse API records before applying defaults or resolving priorities.
  Identity defaults, profiles and host principals must use this merge so a
  string/list declaration cannot overwrite an explicit role declaration.
  */
  merge = base: override:
    recursiveUpdate base override
    // {
      packages =
        recursiveUpdate (filterAttrs (name: _value: elem name policyFields) (recursiveUpdate (base.packages or {}) (override.packages or {})))
        (recursiveUpdate (declarations base) (declarations override));
    };

  resolveGroup = {
    name,
    value,
    protocol ? null,
  }: let
    group = prepareGroup name value;
    selected = recursiveUpdate group (
      if protocol == null
      then {}
      else group.${protocol} or {}
    );
    priorities = filter (entry: entry != null) (map (role: selected.${role} or null) roles);
  in
    unique (priorities ++ (selected.list or []));

  resolve = {
    record,
    protocol ? null,
  }: let
    utilities = record.applications.utilities or null;
    legacyUtilities = optionalAttrs (isUtilityFlags utilities) {
      utilities.list = attrNames (
        filterAttrs
        (_name: config: config.enable)
        utilities
      );
    };
    groups = recursiveUpdate legacyUtilities (declarations record);
    policy =
      filterAttrs
      (name: _value: elem name policyFields)
      (record.packages or {});
  in
    policy
    // mapAttrs
    (name: value: resolveGroup {inherit name value protocol;})
    groups;

  selectedPackages = record: let
    groups = removeAttrs (resolve {inherit record;}) policyFields;
  in
    unique (concatMap (name: groups.${name}) (attrNames groups));

  roleView = entries:
    genAttrs roles (role: let
      index =
        if role == "primary"
        then 0
        else if role == "secondary"
        then 1
        else 2;
    in
      if index < length entries
      then elemAt entries index
      else null);

  # Project the canonical lists for existing consumers while they migrate.
  # All selections remain available through `allowed`, including a fourth or
  # later entry and groups outside the legacy application categories.
  toApplications = {
    packages,
    legacy ? {},
  }: let
    groups = removeAttrs packages policyFields;
    selections = unique (concatMap (name: groups.${name}) (attrNames groups));
    categories = ["browser" "terminal" "launcher" "explorer"];
    selectedUtilities = groups.utilities or [];
    legacyUtilities = let
      value = legacy.utilities or {};
    in
      if isUtilityFlags value
      then value
      else {};
    utilities =
      genAttrs (unique ((attrNames legacyUtilities) ++ selectedUtilities)) (name:
        (legacyUtilities.${name} or {}) // {enable = elem name selectedUtilities;});
    withoutProtocols = value:
      if isAttrs value
      then mapAttrs (_name: withoutProtocols) (removeAttrs value protocols)
      else value;
  in
    recursiveUpdate (withoutProtocols legacy) (
      genAttrs (filter (name: groups ? ${name}) categories) (name: roleView groups.${name})
      // optionalAttrs (groups ? ai-agent) {ai = roleView groups.ai-agent;}
      // optionalAttrs (groups ? editor || groups ? ide) {
        editor =
          optionalAttrs (groups ? editor) {tty = roleView groups.editor;}
          // optionalAttrs (groups ? ide) {gui = roleView groups.ide;};
      }
      // genAttrs (filter (name: groups ? ${name}) ["bar" "prompt"]) (name:
        if groups.${name} == []
        then null
        else elemAt groups.${name} 0)
      // {allowed = selections;}
      // optionalAttrs (groups ? utilities) {inherit utilities;}
    );

  normalize = {
    record,
    protocol ? null,
  }: let
    packages = resolve {inherit record protocol;};
  in
    removeAttrs record ["applications"]
    // {inherit packages;};
in {
  inherit merge normalize policyFields resolve resolveGroup roleView selectedPackages toApplications;
}
