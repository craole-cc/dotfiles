{_, ...}: let
  inherit (_.attrsets.aggregation) recursiveUpdate;
  inherit (_.attrsets.construction) optionalAttrs;
  inherit (_.attrsets.transformation) mapAttrs;
  inherit (_.lists.aggregation) concatMap;
  inherit (_.lists.construction) toList;
  inherit (_.lists.selection) filter;
  inherit (_.lists.transformation) unique;
  inherit (_.types.predicates) isAttrs isString;

  packages = let
    mk = {
      name,
      package,
    }: {inherit name package;};
  in {
    noto = {
      emoji = mk {
        name = "Noto Color Emoji";
        package = "noto-fonts-color-emoji";
      };
      math = mk {
        name = "Noto Math";
        package = "noto-fonts";
      };
      mono = mk {
        name = "Noto Mono";
        package = "noto-fonts";
      };
      music = mk {
        name = "Noto Music";
        package = "noto-fonts";
      };
      sansSerif = mk {
        name = "Noto Sans";
        package = "noto-fonts";
      };
      serif = mk {
        name = "Noto Serif";
        package = "noto-fonts";
      };
    };
    material = {
      sharp = mk {
        name = "Material Symbols Sharp";
        package = "material-symbols";
      };
    };
  };

  categories = with packages; {
    math = [noto.math];
    emoji = [noto.emoji];
    material = [material.sharp];
    monospace = [noto.mono];
    sansSerif = [noto.sansSerif];
    serif = [noto.serif];
    music = [noto.music];
  };

  normalizeEntry = entry: let
    names = {
      "Rubik" = "rubik";
      "Noto Color Emoji" = packages.noto.emoji.package;
      "Noto Math" = packages.noto.math.package;
      "Noto Mono" = packages.noto.mono.package;
      "Noto Music" = packages.noto.music.package;
      "Noto Sans" = packages.noto.sansSerif.package;
      "Noto Serif" = packages.noto.serif.package;
      "Material Symbols Sharp" = packages.material.sharp.package;
      "Material Icons" = "material-icons";
      "Maple Mono NF" = "maple-mono.NF-unhinted";
      "Victor Mono" = "victor-mono";
      "Monaspace Radon Frozen" = "monaspace";
      "Noto Sans CJK" = "noto-fonts-cjk-sans";
    };

    aliases = {
      "maple-mono" = "maple-mono.truetype";
      "nerd-fonts.source-code-pro" = "nerd-fonts.sauce-code-pro";
    };

    name =
      if isString entry
      then entry
      else entry.name or null;
    package =
      if isAttrs entry
      then entry.package or (names.${name} or null)
      else names.${name} or null;
  in
    if !isString name || name == ""
    then throw "A font must be a family name or a record with a non-empty name."
    else {
      inherit name;
      package =
        if isString package
        then aliases.${package} or package
        else package;
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
        ++ toList (value.ordered or value.list or [])
      else toList value;
  in
    unique (map normalizeEntry (filter (entry: entry != null) entries));

  normalizeFonts = fonts: let
    canonical =
      removeAttrs fonts ["sans" "packages" "categories"]
      // optionalAttrs (fonts ? sans || fonts ? sansSerif) {
        sansSerif = fonts.sans or fonts.sansSerif;
      };
  in
    mapAttrs (_: normalizeSelection) canonical;

  getFonts = definition:
    recursiveUpdate
    (normalizeFonts (definition.interface.style.fonts or {}))
    (normalizeFonts (definition.interface.fonts or {}));

  defaults = normalizeFonts categories;

  # Whole role lists replace lower-priority declarations without truncation.
  mkFonts = {
    host ? {},
    user ? {},
  }:
    recursiveUpdate defaults (recursiveUpdate
      (getFonts (host
        // {
          interface = host.defaults.interface or (host.interface or {});
        }))
      (getFonts user));
in {inherit defaults getFonts mkFonts normalizeFonts;}
