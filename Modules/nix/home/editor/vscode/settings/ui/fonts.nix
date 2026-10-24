{fonts, ...}: {
  settings = {
    editor = {
      #~@ Editor
      #> Font family.
      #! overridden (default: "'Droid Sans Mono', monospace")
      fontFamily = fonts.families.monospace;
      #> Font ligatures (bool or `font-feature-settings` string).
      #! overridden (default: false)
      fontLigatures = true;
      #> Font size (px).
      #! overridden (default: 14)
      fontSize = 18;
      #> Font weight (`normal` | `bold` | 1–1000).
      #! overridden (default: "normal")
      fontWeight = 500;
      #> Letter spacing (px).
      #! overridden (default: 0)
      letterSpacing = 0;
      #> Line height. 0 = auto. <8 = multiplier, ≥8 = absolute px.
      #! overridden (default: 0)
      lineHeight = 2;
      #> Allow variable fonts.
      allowVariableFonts = true;
      #> Allow variable line heights.
      allowVariableLineHeights = true;
    };

    terminal.integrated = {
      #~@ Terminal
      #> Font family. Empty = inherit editor's.
      #! overridden (default: "")
      fontFamily = "'Maple Mono NF', 'Lilex Nerd Font', monospace";
      #> Enable terminal font ligatures.
      #! overridden (default: false)
      fontLigatures.enabled = true;
      #> Terminal font size (px).
      #! overridden (default: 14)
      fontSize = 18;
      #> Terminal font weight.
      #! overridden (default: "normal")
      fontWeight = 500;
      #> Terminal bold font weight.
      fontWeightBold = "bold";
      #> Terminal letter spacing (px).
      #! overridden (default: 0)
      letterSpacing = 0;
      #> Terminal line height multiplier.
      #! overridden (default: 1.1)
      lineHeight = 1.2;
    };
  };
}
