{config, lix}: let
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.strings.transformation) escapeShellArg;

  themes = config.themes.icons;
in {
  dark = rec {
    theme = themes.dark.name;
    name = escapeShellArg theme;
    source = concat {
      root = themes.dark.package;
      stem = ["share" "icons" theme];
    };
  };
  light = rec {
    theme = themes.light.name;
    name = escapeShellArg theme;
    source = "${themes.light.package}/share/icons/${theme}";
  };
  resolved = themes.dark;
}
