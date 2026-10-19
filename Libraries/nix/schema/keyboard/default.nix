{_, ...}: let
  inherit (_.attrsets.access) attrNames;
  inherit (_.attrsets.aggregation) recursiveUpdate;
  inherit (_.attrsets.construction) listToAttrs;
  inherit (_.attrsets.transformation) mapAttrs;
  inherit (_.lists.access) elemAt head length tail;
  inherit (_.lists.aggregation) concatMap foldl';
  inherit (_.lists.selection) filter;
  inherit (_.lists.predicates) any;
  inherit (_.lists.transformation) imap0;
  inherit (_.strings.construction) concatStringsSep fromJSON splitString;
  inherit (_.strings.transformation) toUpper;
  inherit (_.types.predicates) isAttrs isList;

  inherit (import ./applications.nix) categories legacyAliases;
  ranks = ["primary" "secondary" "tertiary"];

  normalizeValue = value:
    if isList value
    then map normalizeValue value
    else if isAttrs value
    then let
      normalized =
        mapAttrs (
          name: child:
            if name == "mod" || name == "modifier"
            then
              if child == null
              then null
              else
                concatStringsSep " " (filter (part: part != "") (map toUpper (
                  if isList child
                  then child
                  else splitString " " child
                )))
            else normalizeValue child
        )
        value;
    in
      normalized
      // (
        if normalized ? key && (normalized.modifier or null) != null && (normalized.mod or null) == null
        then {mod = normalized.modifier;}
        else {}
      )
    else value;

  normalizeBinding = binding: let
    normalized = normalizeValue binding;
  in
    normalized
    // (
      if (normalized.modifier or null) != null && (normalized.mod or null) == null
      then {mod = normalized.modifier;}
      else {}
    )
    // (
      if (normalized.action or null) != null && (normalized.kind or null) == null
      then {kind = "exec";}
      else {}
    );

  mergeBindings = previous: declared:
    if isList declared
    then
      imap0 (index: binding:
        recursiveUpdate (
          if isList previous && index < length previous
          then elemAt previous index
          else if isAttrs previous && index == 0
          then previous
          else {}
        )
        binding)
      declared
    else if isList previous
    then
      if previous == []
      then declared
      else [(recursiveUpdate (head previous) declared)] ++ (tail previous)
    else recursiveUpdate previous declared;

  indexed = bindings:
    listToAttrs (imap0 (index: binding: {
        name = toString (index + 1);
        value = {
          key = binding.key or null;
          mod = binding.mod or null;
          command = binding.command or null;
          description = binding.description or "";
          application =
            if (binding.application or null) != null
            then binding.application
            else index + 1;
        };
      })
      bindings);

  legacyScratchpad = spec: let
    ranked = listToAttrs (map (entry: {
      name = toString (entry.index + 1);
      value = (removeAttrs (normalizeBinding spec.${entry.rank}) ["modifier"]) // {application = entry.index + 1;};
    }) (filter (entry: spec ? ${entry.rank}) (imap0 (index: rank: {inherit index rank;}) ranks)));
    explicit = mapAttrs (index: entry:
      (removeAttrs (normalizeBinding entry) ["modifier"])
      // {
        application =
          if (entry.application or null) != null
          then entry.application
          else fromJSON index;
      }) (spec.entries or {});
  in
    (removeAttrs spec ranks) // {entries = recursiveUpdate ranked explicit;};

  applyScope = previous: requested: let
    scope = normalizeValue requested;
    declarations = mapAttrs (
      _: value:
        if isList value
        then map normalizeBinding value
        else normalizeBinding value
    ) (scope.bindings or {});
    replacedAliases = concatMap (
      group:
        if
          isList declarations.${group}
          && (categories ? ${group} || any (binding: (binding.key or null) != null) declarations.${group})
        then legacyAliases.${group} or []
        else []
    ) (attrNames declarations);
    inherited = removeAttrs (previous.bindings or {}) replacedAliases;
    bindings =
      inherited
      // mapAttrs (group: value: let
        merged = mergeBindings (inherited.${group} or {}) value;
      in
        if categories ? ${group} && isList merged
        then
          imap0 (index: binding:
            binding
            // {
              kind = "scratchpad";
              action = null;
              application =
                if (binding.application or null) != null
                then binding.application
                else index + 1;
            })
          merged
        else merged)
      declarations;
    scratchpadLists = listToAttrs (concatMap (
      group:
        if categories ? ${group} && isList bindings.${group}
        then [
          {
            name = categories.${group};
            value.entries = indexed bindings.${group};
          }
        ]
        else []
    ) (attrNames declarations));
  in
    (recursiveUpdate previous scope)
    // {
      inherit bindings;
      scratchpads =
        recursiveUpdate ((previous.scratchpads or {}) // scratchpadLists)
        (mapAttrs (_: legacyScratchpad) (scope.scratchpads or {}));
    };

  finaliseKeyboard = keyboard: let
    normalized = normalizeValue keyboard;
  in
    normalized
    // {
      scratchpads = mapAttrs (_: legacyScratchpad) (normalized.scratchpads or {});
    };

  mergeKeyboards = scopes: finaliseKeyboard (foldl' applyScope {} scopes);
  normalizeKeyboard = keyboard: mergeKeyboards [keyboard];
in {inherit mergeKeyboards normalizeKeyboard;}
