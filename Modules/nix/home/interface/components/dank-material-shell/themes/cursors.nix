{config, lix}: let
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.strings.transformation) escapeShellArg;
in
  mapAttrs (_mode: resolved: rec {
    theme = resolved.name;
    name = escapeShellArg theme;
    source = "${resolved.package}/share/icons/${theme}";
    inherit (resolved) size;
  })
  config.themes.cursors
