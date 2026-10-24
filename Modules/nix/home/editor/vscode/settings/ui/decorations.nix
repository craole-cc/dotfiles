_: {
  extensions = [
    #? Line-width indicators
    "lbragile.line-width-indicator"
    #? Render invisible characters
    "miku3920.vscode-render-special-chars"
    #? Colourful comment tags
    "AllemandInstable.colorful-comments-refreshed"
    #? Better Todo Tree leverages ripgrep to locate custom tags like TODO and FIXME across your workspace. Results are mapped into a dedicated tree view and highlighted directly within your open files. Click any node in the tree to snap your cursor straight to that line of code..
    "FanaticPythoner.better-todo-tree"
  ];

  settings = {
    #~@ TODO Tree
    better-todo-tree.general = {
      automaticGitRefreshInterval = 0;
      debug = false;
      exportPath = "~/better-todo-tree-%Y%m%d-%H%M.txt";
      periodicRefreshInterval = 0;
      revealBehaviour = "start of todo";
      rootFolder = "";
      schemes = ["file" "ssh" "untitled" "vscode-notebook-cell"];
      showActivityBarBadge = false;
      showIconsInsteadOfTagsInStatusBar = false;
      showScanningProgress = "status bar";
      statusBar = "none";
      statusBarClickBehaviour = "reveal";

      # Object-valued setting: keep as a real attrset, do not flatten
      tagGroups = {};

      tags = [
        "BUG"
        "HACK"
        "FIXME"
        "TODO"
        "XXX"
        "[ ]"
        "[x]"
      ];
    };

    #~@ Line Width Indicator
    LWI = {
      #~@ Line-width Indicators
      breakpoints = [
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

      style = {
        #> Font style (`normal` | `italic` | `oblique`).
        #! overridden (default: "normal")
        fontStyle = "italic";
        #> Font weight (`normal` | `bold` | 100–900).
        #! overridden (default: "normal")
        fontWeight = "100";
        #> Counter background colour.
        backgroundColor = "transparent";
        #> Counter margin (px).
        margin = 12;
      };
      #> Languages to exclude from LWI.
      excludedLanguages = ["json" "jsonc" "css" "html" "markdown" "plaintext" "scss" "yaml"];
      #> Comment used to skip formatting on the current line.
      ignoreComment = "// prettier-ignore";
    };

    #~@ Special Characters Indicator
    render-special-chars = {
      #~@ Render special characters
      #> Border around rendered chars.
      #! overridden (default: "")
      border = "1px solid; border-radius: 2px;";
      #> Position of the decoration (`before` | `after`).
      #! overridden (default: "before")
      position = "before";
      #> Delay (ms) before updating decorations.
      #! overridden (default: 500)
      updateDelay = 500;
      #> Background colour of the decoration.
      backgroundColor = "";
      #> Border colour of the decoration.
      borderColor = "";
      #> Text colour of the decoration.
      color = "";
      #> URI schemes to exclude.
      #! overridden (default: [])
      excludedSchemes = ["output" "debug" "git"];
      #> Code point ranges to render.
      #! overridden (default: [])
      include = [
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
      except = [
        "0009" # TAB
        "000A" # LF
        "000D" # CR
        "0020-007E" # Printable ASCII
        "3105-3129" # Bopomofo
        "4E00-9FFF" # CJK Unified Ideographs
        "：；，、。？！〜（）〈〉《》【】「」『』─"
      ];
    };

    #~@ Colorful Comments
    colorful-comments-refreshed.tags = [
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
