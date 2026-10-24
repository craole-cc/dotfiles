_: {
  extensions = ["Catppuccin.catppuccin-vsc"];
  settings = {
    window = {
      #> Detect the system colour scheme and switch themes.
      #! overridden (default: false)
      autoDetectColorScheme = false;

      #> Auto-switch to a high-contrast theme when the OS is in HC mode.
      #! overridden (default: true)
      autoDetectHighContrast = false;
    };

    workbench = {
      #? Active colour theme.
      #! overridden (default: "Dark 2026")
      colorTheme = "Catppuccin Frappé";

      #? Preferred dark theme (used when `autoDetectColorScheme` is on).
      preferredDarkColorTheme = "Catppuccin Frappé";

      #? Preferred light theme.
      preferredLightColorTheme = "Catppuccin Latte";

      #? Preferred HC dark theme.
      preferredHighContrastColorTheme = "Default High Contrast";

      #? Preferred HC light theme.
      preferredHighContrastLightColorTheme = "Default High Contrast Light";

      #? File icon theme.
      #! overridden (default: "vs-seti")
      iconTheme = "material-icon-theme";

      #? Product icon theme.
      #! overridden (default: "Default")
      productIconTheme = "el-vsc-v1-icons";

      #> Overrides for the current colour theme.
      colorCustomizations = {};
    };

    #> Semantic highlighting switch. Colour rules live in `decorations.nix`.
    #! overridden (default: "configuredByTheme")
    editor.semanticHighlighting.enabled = true;
  };
}
