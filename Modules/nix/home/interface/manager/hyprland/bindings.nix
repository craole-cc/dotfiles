{
  ghosttyEnabled,
  keyboard,
  lix,
}: let
  inherit (lix.attrsets.transformation) mapAttrsToList;
  inherit (lix.lists.construction) toList;
  inherit (lix.lists.predicates) elem;
  inherit (lix.lists.selection) filter;
  inherit (lix.strings.construction) concatStringsSep splitString toJSON;

  chord = binding: concatStringsSep " + " ((filter (part: part != "") (splitString " " binding.mod)) ++ [binding.key]);
  valid = binding: (binding.key or null) != null && (binding.mod or null) != null;
  unbind = binding:
    if valid binding
    then "hl.unbind(${toJSON (chord binding)})\n"
    else "";
  render = group: binding: let
    kind = binding.kind or "exec";
    action = binding.action or null;
    # Scratchpads and the MRU handlers render their own canonical records.
    managedElsewhere = elem group ["windowCycle" "windowCycleReverse" "windowCycleRelease" "windowLast"];
    flags = ''{ description = ${toJSON (binding.description or group)}, release = ${toJSON (binding.release or false)}, non_consuming = ${toJSON (binding.nonConsuming or false)}, repeating = ${toJSON (binding.repeating or false)}, locked = ${toJSON (binding.locked or false)} }'';
    dispatch =
      if kind == "hyprland"
      then "hl.dsp.${action}"
      else if kind == "hyprland-function"
      then action
      else if kind == "global"
      then "hl.dsp.global(${toJSON action})"
      else "hl.dsp.exec_cmd(${toJSON action})";
  in
    if !(binding.enable or true) || managedElsewhere || !valid binding || kind == "scratchpad" || action == null || action == "" || (group == "ghosttyQuickTerminal" && !ghosttyEnabled)
    then ""
    else
      unbind binding
      + ''
        hl.bind(${toJSON (chord binding)}, ${dispatch}, ${flags})
      '';
in
  concatStringsSep "" (map unbind (keyboard.unbind or []))
  + concatStringsSep "" (mapAttrsToList (
      group: bindings:
        concatStringsSep "" (map (render group) (toList bindings))
    )
    keyboard.bindings)
