_: {
  extensions = [
    #? Line-width indicators
    "lbragile.line-width-indicator"
    #? Render invisible characters
    "miku3920.vscode-render-special-chars"
    #? Colourful comment tags
    "AllemandInstable.colorful-comments-refreshed"
  ];

  settings = {
    #~@ Semantic token colour rules
    #> Colour and style for semantic token types.
    #! overridden (default: {})
    "editor.semanticTokenColorCustomizations" = {
      rules = {
        "*.static".italic = true;
        interface.italic = true;
        keyword.italic = true;
        selfParameter.italic = true;
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
        {
          scope = [
            "comment"
            "emphasis"
            "entity.name.tag.doctype"
            "entity.other.attribute-name"
            "keyword"
            "keyword.control"
            "keyword.operator.comparison"
            "keyword.operator.expression.delete"
            "keyword.operator.new"
            "keyword.operator.expression"
            "keyword.operator.cast"
            "keyword.operator.relational"
            "keyword.operator.sizeof"
            "italic"
            "markup.changed"
            "markup.deleted.diff"
            "markup.italic"
            "markup.italic.markdown"
            "markup.quote"
            "markup.quote.markdown"
            "meta.decorator punctuation.decorator"
            "meta.delimiter.period"
            "meta.diff.header.git"
            "meta.diff.header.from-file"
            "meta.diff.header.to-file"
            "markup.inserted.diff"
            "meta.class meta.method.declaration meta.var.expr storage.type.js"
            "meta.tag.sgml.doctype"
            "meta.selector"
            "punctuation.accessor"
            "punctuation.definition.comment"
            "punctuation.definition.template-expression.begin"
            "punctuation.definition.template-expression.end"
            "punctuation.section.embedded"
            "quote"
            "source.js constant.other.object.key.js string.unquoted.label.js"
            "storage"
            "storage.type"
            "storage.modifier"
            "text.html.basic entity.other.attribute-name.html"
            "text.html.basic entity.other.attribute-name"
            "variable.language"
            "variable.other.object.property"
          ];
          settings = {fontStyle = "italic";};
        }
      ];
    };

    #> UI colour overrides.
    #! overridden (default: {})
    "workbench.colorCustomizations" = {};

    #~@ Bracket Colorization & Guides
    #> Per-type bracket colour pools.
    #! overridden (default: false)
    "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
    #> Vertical bracket guides.
    #?  - true | active | false
    #! overridden (default: false)
    "editor.guides.bracketPairs" = "active";
    #> Horizontal bracket guides.
    #?  - true | active | false
    "editor.guides.bracketPairsHorizontal" = "active";
    #> Highlight active bracket pair.
    "editor.guides.highlightActiveBracketPair" = true;
    #> Highlight active indent guide.
    #?  - true | always | false
    "editor.guides.highlightActiveIndentation" = true;
    #> Show indent guides.
    "editor.guides.indentation" = true;
    #> Highlight matching brackets.
    #?  - always | near | never
    #! overridden (default: "always")
    "editor.matchBrackets" = "never";

    #~@ Line-width Indicators
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
    #> Font style (`normal` | `italic` | `oblique`).
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

    #~@ Render special characters
    #> Border around rendered chars.
    #! overridden (default: "")
    "render-special-chars.border" = "1px solid; border-radius: 2px;";
    #> Position of the decoration (`before` | `after`).
    #! overridden (default: "before")
    "render-special-chars.position" = "before";
    #> Delay (ms) before updating decorations.
    #! overridden (default: 500)
    "render-special-chars.updateDelay" = 500;
    #> Background colour of the decoration.
    "render-special-chars.backgroundColor" = "";
    #> Border colour of the decoration.
    "render-special-chars.borderColor" = "";
    #> Text colour of the decoration.
    "render-special-chars.color" = "";
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

    #~@ Colorful Comments
    #! overridden (default: [])
    "colorful-comments-refreshed.tags" = [
      # Core markers
      {
        tag = "@";
        italic = true;
        backgroundColor = "#89a25722";
        color = "#89a257";
      }
      {
        tag = "~@";
        italic = true;
        backgroundColor = "#89a25722";
        color = "#89a257";
      }
      {
        tag = "!";
        backgroundColor = "transparent";
        color = "#ff0000";
      }
      {
        tag = "/";
        italic = true;
        backgroundColor = "#bd8af41a";
        color = "#bd8af4";
      }
      {
        tag = "|";
        italic = true;
        color = "hsl(148, 70%, 50%)";
      }
      {
        tag = "region";
        italic = true;
        backgroundColor = "#bd8af41a";
        color = "#bd8af4";
      }
      {
        tag = "endregion";
        italic = true;
        backgroundColor = "#bd8af41a";
        color = "#bd8af4";
      }

      # Keywords
      {
        tag = "HELP";
        italic = true;
        backgroundColor = "transparent";
        color = "#fed200";
      }
      {
        tag = "shellcheck";
        italic = true;
        backgroundColor = "transparent";
        color = "#fd7b30";
      }
      {
        tag = "DOC ";
        italic = true;
        backgroundColor = "transparent";
        color = "#08c3d4";
      }
      {
        tag = "TOC ";
        italic = true;
        backgroundColor = "transparent";
        color = "#08c3d4";
      }
      {
        tag = "USAGE ";
        italic = true;
        backgroundColor = "transparent";
        color = "#08c3d4";
      }
      {
        tag = " http";
        italic = true;
        backgroundColor = "transparent";
        color = "#3498DB";
      }
      {
        tag = " -- ";
        bold = true;
        backgroundColor = "transparent";
        color = "#3498DB";
      }
      {
        tag = ".";
        bold = true;
        backgroundColor = "transparent";
        color = "#3498DB";
      }
      {
        tag = "result:";
        bold = true;
        backgroundColor = "transparent";
        color = "#3498DB";
      }
      {
        tag = "todo";
        italic = true;
        underline = true;
        backgroundColor = "transparent";
        color = "hsla(27, 90%, 55%, 0.75)";
      }
      {
        tag = "def";
        backgroundColor = "transparent";
        color = "hsla(43, 50%, 50%, 0.95)";
      }

      # Symbols
      {
        tag = "=";
        backgroundColor = "transparent";
        color = "hsla(335, 80%, 38%, 0.75)";
      }
      {
        tag = "+";
        backgroundColor = "transparent";
        color = "hsla(335, 80%, 38%, 0.75)";
      }
      {
        tag = ">";
        bold = true;
        italic = true;
        underline = true;
        backgroundColor = "transparent";
        color = "hsla(162, 70%, 30%, 0.95)";
      }
      {
        tag = "?";
        bold = true;
        italic = true;
        underline = true;
        backgroundColor = "transparent";
        color = "hsla(162, 70%, 30%, 0.5)";
      }

      # Box drawing
      {
        tag = "╔";
        italic = true;
        backgroundColor = "hsla(300,86%,47%, 0.15)";
        color = "hsl(300,86%,47%)";
      }
      {
        tag = "║";
        italic = true;
        backgroundColor = "hsla(300,86%,47%, 0.15)";
        color = "hsl(300,86%,47%)";
      }
      {
        tag = "╠";
        italic = true;
        backgroundColor = "hsla(300,86%,47%, 0.15)";
        color = "hsl(300,86%,47%)";
      }
      {
        tag = "╚";
        italic = true;
        backgroundColor = "hsla(300,86%,47%, 0.15)";
        color = "hsl(300,86%,47%)";
      }
    ];
  };
}
