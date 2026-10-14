{lib, ...}: let
  inherit (lib.strings) hasInfix toLower;

  mkStyle = {
    host,
    user,
  }: let
    legacyTheme = user.interface.style.theme or host.interface.style.theme or {};
    mode = toLower (
      user.theme.modes.default.palette.variant
      or host.theme.modes.default.palette.variant
      or legacyTheme.mode
      or "dark"
    );
    palette = user.theme.modes.${mode}.palette or host.theme.modes.${mode}.palette or {};
    variant = toLower (palette.name or legacyTheme.${mode} or "Catppuccin Latte");
    accent = toLower (palette.accent or legacyTheme.accent or "rosewater");
    flavor =
      if hasInfix "frappe" variant || hasInfix "frappé" variant
      then "frappe"
      else if hasInfix "latte" variant
      then "latte"
      else if hasInfix "mocha" variant
      then "mocha"
      else if hasInfix "macchiato" variant
      then "macchiato"
      else if mode == "dark"
      then "frappe"
      else "latte";
    catppuccin = hasInfix "catppuccin" variant;
    fonts =
      user.interface.style.fonts or host.interface.style.fonts or {
        emoji = "Noto Color Emoji";
        monospace = "Maple Mono NF";
        sans = "Monaspace Radon Frozen";
        serif = "Noto Serif";
        material = "Material Symbols Sharp";
        clock = "Rubik";
      };
    icons = {
      dark =
        user.theme.modes.dark.icon
        or user.style.icons.dark
        or host.theme.modes.dark.icon
        or host.style.icons.dark
        or "candy-icons";
      light =
        user.theme.modes.light.icon
        or user.style.icons.light
        or host.theme.modes.light.icon
        or host.style.icons.light
        or "candy-icons";
    };
    opacity = {
      terminal = {
        light =
          user.theme.modes.light.opacity.terminal
          or user.style.opacity.terminal.light
          or host.theme.modes.light.opacity.terminal
          or host.style.opacity.terminal.light
          or 1.0;
        dark =
          user.theme.modes.dark.opacity.terminal
          or user.style.opacity.terminal.dark
          or host.theme.modes.dark.opacity.terminal
          or host.style.opacity.terminal.dark
          or 1.0;
      };
    };
  in {
    inherit
      fonts
      mode
      variant
      accent
      flavor
      catppuccin
      icons
      opacity
      ;
  };

  exports = {inherit mkStyle;};
in
  exports
  // {
    __rootAliases = {
      mkUserStyle = mkStyle;
    };
  }
