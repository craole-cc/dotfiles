{
  mkGroup,
  mkEntry,
  ...
}: let
  files = mkEntry {
    enable = true;
    extensions = [
      #? Keyboard-driven file browser
      "bodil.file-browser"
      #? Sort workspace folders alphabetically
      "iciclesoft.workspacesort"
      #? Diff two folders side by side
      "moshfeu.compare-folders"
      #? Multi-workspace file search
      "joshmu.periscope"
    ];
  };

  text = mkEntry {
    enable = true;
    extensions = [
      #? Text transformation utilities
      "dakara.transformer"
      #? Convert case (camel, snake, kebab…)
      "wmaurer.change-case"
      #? Sort selected lines
      "tyriar.sort-lines"
      #? Toggle editor settings via keybind
      "rebornix.toggle"
    ];
  };

  env = mkEntry {
    enable = true;
    extensions = [
      #? .env file support
      "dotenv.dotenv-vscode"
      #? .env syntax highlighting
      # "irongeek.vscode-env"
      #? Respect .editorconfig files
      # "editorconfig.editorconfig"
    ];
    userSettings = {
      "dotenv.enableAutocloaking" = false;
    };
  };

  license = mkEntry {
    enable = true;
    extensions = [
      #? License chooser and inserter
      "ultram4rine.vscode-choosealicense"
    ];
    userSettings = {
      "license.author" = "Craig 'Craole' Cole";
      "license.default" = "mit";
    };
  };

  spelling = mkEntry {
    enable = false;
    extensions = [
      #? Typos spell checker (fast, Rust-based)
      "tekumara.typos-vscode"
      #? CSpell spell checker
      "streetsidesoftware.code-spell-checker"
      #? Spell checking via system dictionary
      "ban.spellright"
      #? Highlight invisible/problematic chars
      "nhoizey.gremlins"
    ];
    userSettings = {
      "typos.diagnosticSeverity" = "Hint";
      "harper.dialect" = "British";
      "harper.workspaceDictPath" = ".harper-dictionary.txt";
      "harper.excludePatterns" = [];
      "harper.linters.Dashes" = false;
      "harper.linters.NumericRangeEnDash" = false;
      "harper.linters.OxfordComma" = false;
      "harper.linters.SentenceCapitalization" = false;
    };
  };

  runners = mkEntry {
    enable = true;
    extensions = [
      #? Reload window command
      "natqe.reload"
      #? Run code snippets in any language
      "formulahendry.code-runner"
      #? Test explorer sidebar UI
      "hbenl.vscode-test-explorer"
      #? Bridge legacy Test Explorer adapters into VS Code's native test API
      "ms-vscode.test-adapter-converter"
      #? Run the configured Statix and ShellCheck diagnostic targets
      "vix.lint-runner"
    ];
  };

  viewers = mkEntry {
    enable = false;
    extensions = [
      #? PlantUML diagram preview and export
      "jebbs.plantuml"
      #? Local dev server with live reload
      "ritwickdey.liveserver"
      #? PDF viewer inside VSCode
      "tomoki1207.pdf"
      #? SVG file preview
      "vitaliymaz.vscode-svg-previewer"
      #? Show import bundle size inline
      "wix.vscode-import-cost"
    ];
  };

  keybindings = mkEntry {
    enable = true;
    extensions = [
      #? Restore familiar Windows keybindings
      "smcpeak.default-keys-windows"
    ];
    userSettings = {
      "vscode-default-keybindings.windowsKeybindings" = true;
    };
  };

  feeds = mkEntry {
    enable = true;
    extensions = [];
    userSettings = {
      "rss.accounts" = {
        "fb0e47b0-9982-11ef-a698-3778cde2492f" = {
          name = "Default";
          type = "local";
          feeds = [];
        };
      };
    };
  };

  spreadsheets = mkEntry {
    enable = true;
    extensions = ["mescius.spreadjs-xlsx-editor"];
    userSettings = {
      "spreadjs.ribbonMode" = "toolbar";
    };
  };

  integrations = mkEntry {
    enable = true;
    extensions = [];
    userSettings = {
      "atlascode.jira.enabled" = false;
    };
  };
in {entries = {inherit files text env license spelling runners viewers keybindings feeds spreadsheets integrations;};}
