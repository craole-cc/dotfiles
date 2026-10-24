{fonts, ...}: {
  settings = {
    # ── Editor ───────────────────────────────────────────────────────────
    #> Font family.
    #! overridden (default: "'Droid Sans Mono', monospace")
    "editor.fontFamily" = fonts.families.monospace;
    #> Font ligatures (bool or `font-feature-settings` string).
    #! overridden (default: false)
    "editor.fontLigatures" = true;
    #> Font size (px).
    #! overridden (default: 14)
    "editor.fontSize" = 18;
    #> Font weight (`normal` | `bold` | 1–1000).
    #! overridden (default: "normal")
    "editor.fontWeight" = 500;
    #> Letter spacing (px).
    #! overridden (default: 0)
    "editor.letterSpacing" = 0;
    #> Line height. 0 = auto. <8 = multiplier, ≥8 = absolute px.
    #! overridden (default: 0)
    "editor.lineHeight" = 2;
    #> Allow variable fonts.
    "editor.allowVariableFonts" = true;
    #> Allow variable line heights.
    "editor.allowVariableLineHeights" = true;

    # ── Terminal ─────────────────────────────────────────────────────────
    #> Font family. Empty = inherit editor's.
    #! overridden (default: "")
    "terminal.integrated.fontFamily" = "'Maple Mono NF', 'Lilex Nerd Font', monospace";
    #> Enable terminal font ligatures.
    #! overridden (default: false)
    "terminal.integrated.fontLigatures.enabled" = true;
    #> Terminal font size (px).
    #! overridden (default: 14)
    "terminal.integrated.fontSize" = 18;
    #> Terminal font weight.
    #! overridden (default: "normal")
    "terminal.integrated.fontWeight" = 500;
    #> Terminal bold font weight.
    "terminal.integrated.fontWeightBold" = "bold";
    #> Terminal letter spacing (px).
    #! overridden (default: 0)
    "terminal.integrated.letterSpacing" = 0;
    #> Terminal line height multiplier.
    #! overridden (default: 1.1)
    "terminal.integrated.lineHeight" = 1.2;
  };
}
