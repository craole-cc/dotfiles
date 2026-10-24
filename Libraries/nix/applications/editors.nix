{_, ...}: let
  inherit (_.attrsets.resolution) parseVscodeExt vscodePackage;
  inherit (_.attrsets.aggregation) mergeSafe;
  inherit (_.attrsets.construction) optionalAttrs;
  inherit (_.lists.construction) optionals;

  __exports = {
    internal = {
      inherit
        mkVSCodeFeature
        mkVSCodeSubFeature
        mkHelixFeature
        mkNeovimFeature
        normalizeSettings
        flattenVSCodeSetting
        ;
    };
    external = __exports.internal;
  };

  # Accept both `settings` (user-facing alias) and `userSettings` (canonical)
  # and normalize to `userSettings`.
  #
  # `userSettings` is the base, `settings` the override. `mergeSafe` deep-merges
  # plain attrsets, but treats module-system values (`mkMerge`, `mkIf`,
  # `mkOverride`, option declarations, …) as atomic. A plain empty `{}` on
  # either side is the identity — so a feature layer passing
  # `userSettings = mkMerge [...]` plus the default `settings = {}` keeps the
  # accumulated module value intact (this is what Option B of `mergeSafe`'s
  # predicate fixes).
  #
  # No `!= {}` comparison, so `settings = mkMerge [...]` doesn't throw.
  normalizeSettings = {
    settings ? {},
    userSettings ? {},
    ...
  }:
    mergeSafe [userSettings settings];

  flattenVSCodeSetting = prefix: value:
    if builtins.isAttrs value && value != {}
    then
      builtins.foldl' (
        result: key:
          result
          // flattenVSCodeSetting (
            if prefix == ""
            then key
            else "${prefix}.${key}"
          )
          value.${key}
      ) {} (builtins.attrNames value)
    else {"${prefix}" = value;};

  mkVSCodeFeature = {
    extensions,
    settings ? {},
    userSettings ? {},
    keybindings ? [],
    pkgs,
    inputs,
    ...
  } @ args: let
    enable = args.enable or (args.enabled or false);
    effectiveSettings = normalizeSettings {inherit settings userSettings;};
  in
    {
      extensions = optionals enable (
        map (
          extension: let
            identifier = parseVscodeExt extension;
          in
            vscodePackage {
              inherit pkgs inputs;
              entry = extension;
              default = throw "Required VS Code extension '${identifier.publisher}.${identifier.name}' was not found in the configured extension catalogues.";
            }
        )
        extensions
      );
      keybindings = optionals enable keybindings;
    }
    // optionalAttrs enable {userSettings = effectiveSettings;};

  mkVSCodeSubFeature = {
    extensions ? [],
    settings ? {},
    userSettings ? {},
    keybindings ? [],
    ...
  } @ args: let
    enable = args.enable or (args.enabled or false);
    effectiveSettings = flattenVSCodeSetting "" (
      normalizeSettings {inherit settings userSettings;}
    );
  in
    {
      extensions = optionals enable extensions;
      keybindings = optionals enable keybindings;
    }
    // optionalAttrs enable {userSettings = effectiveSettings;};

  mkHelixFeature = {
    enable,
    languages ? {},
    themes ? {},
  }:
    optionalAttrs enable {inherit languages themes;};

  mkNeovimFeature = {
    enable,
    plugins ? [],
    extraConfig ? "",
  }:
    optionalAttrs enable {inherit plugins extraConfig;};
in
  __exports.internal // {__rootAliases = __exports.internal;}
