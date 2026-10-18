{
  config,
  inputs,
  lix,
  pkgs,
  style,
  user,
}: let
  inherit (lix.attrsets.access) getAttr;
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.lists.aggregation) concatMap;
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.strings.transformation) escapeShellArg;

  icons = let
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
  };
  cursors = mapAttrs (_mode: resolved: rec {
    theme = resolved.name;
    name = escapeShellArg theme;
    source = "${resolved.package}/share/icons/${theme}";
    inherit (resolved) size;
  }) config.themes.cursors;
  catppuccin = import ./catppuccin.nix {inherit config lix user;};
  foot = import ./foot.nix {inherit config lix pkgs user;};
  ghostty = import ./ghostty.nix {inherit config pkgs style;};
  helix = import ./helix.nix {inherit config inputs lix pkgs;};
  hermes = import ./hermes.nix {inherit config lix pkgs;};
  kitty = import ./kitty.nix {inherit config pkgs style;};

  mkThemeModals = {
    modes ? ["dark" "light"],
    types ? ["icons" "cursors"],
  }: let
    mk = mode: type: let
      selected = getAttr mode (getAttr type {inherit icons cursors;});
    in {"icons/${selected.theme}" = {inherit (selected) source;};};
  in
    concatMap (type: map (mode: mk mode type) modes) types;

  dataFile = mergeSafe (mkThemeModals {});

  resolved = {inherit (config.themes) cursors icons;};
in {inherit catppuccin cursors dataFile foot ghostty helix hermes icons kitty resolved;}
