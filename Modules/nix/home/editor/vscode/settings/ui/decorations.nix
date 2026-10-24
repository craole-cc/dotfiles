_: {
  extensions = [
    #? Colorize brackets with a per-type palette
    "CoenraadS.bracket-pair-colorizer-2"
    #? Line-width indicators
    "lbragile.line-width-indicator"
    #? Render invisible characters
    "miku3920.vscode-render-special-chars"
    #? Colourful comment tags
    "AllemandInstable.colorful-comments-refreshed"
    #? Underlined matching brackets
    "rafamel.subtle-brackets"
  ];

  settings = {
    # ── Semantic token colour rules ─────────────────────────────────────
    #> Colour and style for semantic token types.
    #! overridden (default: {})
    "editor.semanticTokenColorCustomizations" = {
      rules = {
        "*.static" = {italic = true;};
        interface = {italic = true;};
        keyword = {italic = true;};
        selfParameter = {italic = true;};
      };
    };

    #> Colour and style for TextMate scopes.
    #! overridden (default: {})
    "editor.tokenColorCustomizations" = {
      "[*Light*]" = {
        textMateRules = [
          {
            scope = "ref.matchtext";
            settings = {foreground = "#000";};
          }
        ];
      };
      "[*Dark*]" = {
        textMateRules = [
          {
            scope = "ref.matchtext";
            settings = {foreground = "#fff";};
          }
        ];
      };
      textMateRules = [
        # (Your full textMateRules array goes here; same shape as your settings.json)
      ];
    };

    #> UI colour overrides.
    #! overridden (default: {})
    "workbench.colorCustomizations" = {};

    # ── Line-width indicators ───────────────────────────────────────────
    #! overridden (default: [])
    "LWI.breakpoints" = [
      {
        color = "rgb(0, 255, 0, 0.6)";
        column = 54;
      }
      {
        color = "rgb(244, 180, 0, 0.6)";
        column = 68;
      }
      {
        color = "rgb(255, 0, 0, 0.6)";
        column = 79;
      }
    ];
    #> Font style for the counter (`normal` | `italic` | `oblique`).
    #! overridden (default: "normal")
    "LWI.style.fontStyle" = "italic";
    #> Font weight (`normal` | `bold` | 100–900).
    #! overridden (default: "normal")
    "LWI.style.fontWeight" = "100";
    #> Languages to exclude from LWI.
    "LWI.excludedLanguages" = ["json" "jsonc" "css" "html" "markdown" "plaintext" "scss" "yaml"];
    #> Comment used to skip formatting on the current line.
    "LWI.ignoreComment" = "// prettier-ignore";
    #> Counter background colour.
    "LWI.style.backgroundColor" = "transparent";
    #> Counter margin (px).
    "LWI.style.margin" = 10;

    # ── Render special characters ───────────────────────────────────────
    #> Border around rendered chars.
    #! overridden (default: "1px solid; border-radius: 2px;")
    "render-special-chars.border" = "1px solid; border-radius: 2px;";
    #> Position of the decoration (`before` | `after`).
    #! overridden (default: "before")
    "render-special-chars.position" = "before";
    #> Delay (ms) before updating decorations.
    #! overridden (default: 500)
    "render-special-chars.updateDelay" = 500;
    #> URI schemes to exclude.
    #! overridden (default: [])
    "render-special-chars.excludedSchemes" = ["output" "debug" "git"];
    #> Code point ranges to render.
    #! overridden (default: [])
    "render-special-chars.include" = [
      "0000-0008" # NULL–BACKSPACE
      "000B" # Vertical tab
      "000C" # Form feed
      "000E-001F" # SHIFT OUT–INFORMATION SEPARATOR ONE
      "007F-009F" # DELETE–APPLICATION PROGRAM COMMAND
      "00A0-4DFF" # Latin-1 Supplement–Hangul Compatibility Jamo
      "A000-10FFFF" # Yi Syllables–Supplementary Private Use Area-B
    ];
    #> Code point ranges to exclude (drawn from `include`).
    #! overridden (default: [])
    "render-special-chars.except" = [
      "0009" # TAB
      "000A" # LF
      "000D" # CR
      "0020-007E" # Printable ASCII
      "3105-3129" # Bopomofo
      "4E00-9FFF" # CJK Unified Ideographs
      "：；，、。？！〜（）〈〉《》【】「」『』─"
    ];

    # ── Colorful comments ───────────────────────────────────────────────
    #> Tag list with per-tag colours.
    #! overridden (default: [])
    "colorful-comments-refreshed.tags" = [
      # Your existing 20+ tag entries go here
    ];

    # ── Bracket colorizer ───────────────────────────────────────────────
    #> Enable per-type bracket colour pools.
    "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
    #> Show bracket guides (`true` | `active` | `false`).
    #! overridden (default: false)
    "editor.guides.bracketPairs" = "active";
    #> Horizontal bracket guides (`true` | `active` | `false`).
    "editor.guides.bracketPairsHorizontal" = "active";
    #> Highlight the active bracket pair.
    "editor.guides.highlightActiveBracketPair" = true;
    #> Highlight the active indent guide (`true` | `always` | `false`).
    "editor.guides.highlightActiveIndentation" = true;
    #> Show indent guides.
    "editor.guides.indentation" = true;
    #> Highlight matching brackets (`always` | `near` | `never`).
    #! overridden (default: "always")
    "editor.matchBrackets" = false;
  };
}
