{
  config,
  lix,
}: let
  inherit (lix.attrsets.access) getAttr;
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.lists.aggregation) concatMap;
  inherit (lix.strings.transformation) escapeShellArg;

  themes = {
    icons = {
      dark = config.themes.icons.dark;
      light = config.themes.icons.light;
    };
    cursors = {
      dark = config.themes.cursors.dark;
      light = config.themes.cursors.light;
    };
  };

  cursors =
    mapAttrs (_: resolved: rec {
      theme = resolved.name;
      name = escapeShellArg theme;
      source = "${resolved.package}/share/icons/${theme}";
      inherit (resolved) size;
    })
    themes.cursors;

  icons = {
    dark = rec {
      theme = themes.icons.dark.name;
      name = escapeShellArg theme;
      source = concat {
        root = themes.icons.dark.package;
        stem = ["share" "icons" theme];
      };
    };
    light = rec {
      theme = themes.icons.light.name;
      name = escapeShellArg theme;
      source = "${themes.icons.light.package}/share/icons/${theme}";
    };
    resolved = themes.icons.dark;
  };

  mkThemeModals = {
    modes ? ["dark" "light"],
    types ? ["icons" "cursors"],
  }: let
    mk = mode: type: let
      selected = getAttr mode (getAttr type {inherit icons cursors;});
    in {"icons/${selected.theme}" = {inherit (selected) source;};};
  in
    concatMap (type: map (mode: mk mode type) modes) types;
in {
  inherit icons cursors;
  resolved = themes;
  dataFile = mergeSafe (mkThemeModals {});
}
