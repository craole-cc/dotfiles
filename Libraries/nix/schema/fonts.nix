{_, ...}: let
  inherit (_.attrsets.aggregation) recursiveUpdate;
  inherit (_.attrsets.construction) optionalAttrs;
  inherit (_.attrsets.transformation) mapAttrs;
  inherit (_.lists.aggregation) concatMap;
  inherit (_.lists.construction) toList;
  inherit (_.lists.selection) filter;
  inherit (_.lists.transformation) unique;
  inherit (_.types.predicates) isAttrs isString;

  packages = {
    "Rubik" = "rubik";
    "Noto Color Emoji" = "noto-fonts-color-emoji";
    "Material Symbols Sharp" = "material-symbols";
    "Material Icons" = "material-icons";
    "Maple Mono NF" = "maple-mono.NF-unhinted";
    "Victor Mono" = "victor-mono";
    "Monaspace Radon Frozen" = "monaspace";
    "Noto Serif" = "noto-fonts";
    "Noto Sans CJK" = "noto-fonts-cjk-sans";
  };

  packageAliases = {
    "maple-mono" = "maple-mono.truetype";
    "nerd-fonts.source-code-pro" = "nerd-fonts.sauce-code-pro";
  };

  normalizeEntry = entry: let
    name =
      if isString entry
      then entry
      else entry.name or null;
    package =
      if isAttrs entry
      then entry.package or (packages.${name} or null)
      else packages.${name} or null;
  in
    if !isString name || name == ""
    then throw "A font must be a family name or a record with a non-empty name."
    else {
      inherit name;
      package =
        if isString package
        then packageAliases.${package} or package
        else package;
    };

  # Ranked legacy entries precede the remaining ordered selections.
  normalizeSelection = value: let
    entries =
      if isAttrs value && !(value ? name)
      then
        concatMap (rank: toList (value.${rank} or [])) ["primary" "secondary" "tertiary"]
        ++ toList (value.ordered or value.list or [])
      else toList value;
  in
    unique (map normalizeEntry (filter (entry: entry != null) entries));

  normalizeFonts = fonts: let
    canonical =
      removeAttrs fonts ["sansSerif"]
      // optionalAttrs (fonts ? sans || fonts ? sansSerif) {
        sans = fonts.sans or fonts.sansSerif;
      };
  in
    mapAttrs (_: normalizeSelection) canonical;

  getFonts = definition:
    recursiveUpdate
    (normalizeFonts (definition.interface.style.fonts or {}))
    (normalizeFonts (definition.interface.fonts or {}));

  defaults = normalizeFonts {
    math = "Rubik";
    emoji = "Noto Color Emoji";
    material = "Material Symbols Sharp";
    monospace = "Maple Mono NF";
    sans = "Monaspace Radon Frozen";
    serif = "Noto Serif";
    cjk = "Noto Sans CJK";
  };

  # Whole role lists replace lower-priority declarations without truncation.
  mkFonts = {
    host ? {},
    user ? {},
  }:
    recursiveUpdate defaults (recursiveUpdate
      (getFonts (host // {interface = host.defaults.interface or (host.interface or {});}))
      (getFonts user));
in {
  inherit defaults getFonts mkFonts normalizeFonts;
}
