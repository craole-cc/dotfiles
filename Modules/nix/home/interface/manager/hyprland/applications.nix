{
  apps,
  lix,
  scratchpads,
  terminalLaunch,
}: let
  inherit (lix.attrsets.transformation) filterAttrs mapAttrsToList;
  inherit (lix.lists.access) elemAt length;
  inherit (lix.lists.transformation) imap0;
  inherit (lix.strings.construction) concatStringsSep splitString toJSON;
  inherit (lix.types.predicates) isAttrs;

  roles = ["primary" "secondary" "tertiary"];
  modifiers = [[] ["SHIFT"] ["ALT"] ["SHIFT" "ALT"] ["CTRL"] ["CTRL" "SHIFT"] ["CTRL" "ALT"] ["CTRL" "SHIFT" "ALT"]];
  roleAt = index:
    if index < length roles
    then elemAt roles index
    else toString (index + 1);
  extraMods = index:
    if index < length modifiers
    then elemAt modifiers index
    else null;
  chord = mod: key: concatStringsSep " + " ((splitString " " mod) ++ [key]);
  entriesFor = category: (apps.${category} or {}).ordered or [];
  primaryTerminal = apps.terminal.primary or null;
  wrapCommand = entry: command:
    if (entry.needsTerminal or false) && isAttrs primaryTerminal
    then "${primaryTerminal.command} ${primaryTerminal.wrap.execFlag or "-e"} ${command}"
    else command;

  scratchpadBind = category: scratchpad: index: entry: let
    role = roleAt index;
    nonNull = filterAttrs (_: value: value != null);
    configured = (nonNull (scratchpad.${role} or {})) // (nonNull (scratchpad.entries.${toString (index + 1)} or {}));
    extra = extraMods index;
    key = configured.key or scratchpad.key or null;
    mod =
      configured.mod or (
        if extra == null
        then null
        else concatStringsSep " " ([(scratchpad.primary.mod or "SUPER")] ++ extra)
      );
    command = configured.command or null;
    resolvedCommand =
      if command != null
      then command
      else wrapCommand entry (entry.launch.scratchpad or entry.command);
    workspace = "${category}-${role}";
  in
    # Every selected app gets a workspace. Entries beyond the automatic modifier
    # combinations can define their own key/mod through scratchpads.<group>.entries.
    ''
      hl.workspace_rule({ workspace = ${toJSON "special:${workspace}"}, on_created_empty = ${toJSON resolvedCommand} })
    ''
    + (
      if key == null || mod == null
      then ""
      else ''
        hl.unbind(${toJSON (chord mod key)})
        hl.bind(${toJSON (chord mod key)}, hl.dsp.workspace.toggle_special(${toJSON workspace}), { description = ${toJSON "Toggle ${category} ${toString (index + 1)}: ${entry.name}"} })
      ''
    );

  terminalBind = index: entry: let
    extra = extraMods index;
    key = terminalLaunch.key or null;
    mod = terminalLaunch.mod or null;
    binding =
      if mod == null || extra == null
      then null
      else concatStringsSep " + " ((splitString " " mod) ++ extra ++ [key]);
  in
    if key == null || binding == null
    then ""
    else ''
      hl.unbind(${toJSON binding})
      hl.bind(${toJSON binding}, hl.dsp.exec_cmd(${toJSON entry.command}), { description = ${toJSON "Open terminal ${toString (index + 1)}: ${entry.name}"} })
    '';
in {
  terminals = concatStringsSep "" (imap0 terminalBind apps.terminal.ordered);
  scratchpads = concatStringsSep "" (mapAttrsToList (
      category: scratchpad:
        concatStringsSep "" (imap0 (scratchpadBind category scratchpad) (entriesFor category))
    )
    scratchpads);
}
