{_, ...}: let
  inherit (_.attrsets.aggregation) recursiveUpdate;
  inherit (_.attrsets.construction) optionalAttrs;
  inherit (_.attrsets.transformation) mapAttrs;
  inherit (_.lists.aggregation) concatMap;
  inherit (_.lists.construction) toList;
  inherit (_.lists.selection) filter;
  inherit (_.lists.transformation) unique;
  inherit (_.types.predicates) isAttrs isString;

  defaults = let
    mk = {
      name,
      package,
    }: {inherit name package;};
  in {
    math = [
      (mk {
        name = "Noto Math";
        package = "noto-fonts";
      })
    ];
    emoji = [
      (mk {
        name = "Noto Color Emoji";
        package = "noto-fonts-color-emoji";
      })
    ];
    material = [
      (mk {
        name = "Material Symbols Sharp";
        package = "material-symbols";
      })
    ];
    monospace = [
      (mk {
        name = "Noto Mono";
        package = "noto-fonts";
      })
    ];
    music = [
      (mk {
        name = "Noto Music";
        package = "noto-fonts";
      })
    ];
    sansSerif = [
      (mk {
        name = "Noto Sans";
        package = "noto-fonts";
      })
    ];
    serif = [
      (mk {
        name = "Noto Serif";
        package = "noto-fonts";
      })
    ];
  };

  normalizeEntry = entry: let
    name =
      if isString entry
      then entry
      else entry.name or null;
    package =
      if isAttrs entry
      then entry.package or null
      else null;
  in
    if !isString name || name == ""
    then throw "A font must be a family name or a record with a non-empty name."
    else {
      inherit name;
      package =
        if isString package
        then package
        else null;
    };

  # Ranked legacy entries precede the remaining ordered selections.
  normalizeSelection = value: let
    entries =
      if isAttrs value && !(value ? name)
      then
        (
          concatMap
          (rank: toList (value.${rank} or []))
          ["primary" "secondary" "tertiary"]
        )
        ++ toList (value.ordered or (value.list or []))
      else toList value;
  in
    unique (map normalizeEntry (filter (entry: entry != null) entries));

  normalizeFonts = fonts: let
    selections = (fonts.categories or {}) // (removeAttrs fonts ["categories" "packages"]);
    canonical =
      (removeAttrs selections ["sans"])
      // optionalAttrs (selections ? sans || selections ? sansSerif) {
        sansSerif = selections.sansSerif or selections.sans;
      };
  in
    mapAttrs (_: normalizeSelection) canonical;

  # TODO: this should use a better merger
  getFonts = definition:
    recursiveUpdate
    (normalizeFonts (definition.interface.style.fonts or {}))
    (normalizeFonts (definition.interface.fonts or {}));

  # Whole role lists replace lower-priority declarations without truncation.
  mkFonts = {
    host ? {},
    user ? {},
  }:
    recursiveUpdate defaults (
      recursiveUpdate
      (getFonts (host // {interface = host.defaults.interface or (host.interface or {});}))
      (getFonts user)
    );
in {inherit defaults getFonts mkFonts normalizeFonts;}
