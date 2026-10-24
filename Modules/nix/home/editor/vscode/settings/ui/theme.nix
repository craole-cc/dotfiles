_: {
  settings = {
    #> Detect the system colour scheme and switch themes.
    #! overridden (default: false)
    "window.autoDetectColorScheme" = false;

    #> Auto-switch to a high-contrast theme when the OS is in HC mode.
    #! overridden (default: true)
    "window.autoDetectHighContrast" = false;

    #? Active colour theme.
    #! overridden (default: "Dark 2026")
    "workbench.colorTheme" = "Catppuccin Frappé";

    #? Preferred dark theme (used when `autoDetectColorScheme` is on).
    "workbench.preferredDarkColorTheme" = "Catppuccin Frappé";

    #? Preferred light theme.
    "workbench.preferredLightColorTheme" = "Catppuccin Latte";

    #? Preferred HC dark theme.
    "workbench.preferredHighContrastColorTheme" = "Default High Contrast";

    #? Preferred HC light theme.
    "workbench.preferredHighContrastLightColorTheme" = "Default High Contrast Light";

    #? File icon theme.
    #! overridden (default: "vs-seti")
    "workbench.iconTheme" = "material-icon-theme";

    #? Product icon theme.
    #! overridden (default: "Default")
    "workbench.productIconTheme" = "el-vsc-v1-icons";

    #> Overrides for the current colour theme.
    "workbench.colorCustomizations" = {};

    #> Semantic highlighting switch. Colour rules live in `decorations.nix`.
    #! overridden (default: "configuredByTheme")
    "editor.semanticHighlighting.enabled" = true;
  };
}
