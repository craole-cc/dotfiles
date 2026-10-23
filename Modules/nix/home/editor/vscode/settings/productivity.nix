{
  inputs,
  mkMerge,
  flatten,
  mkVSCodeFeature,
  mkVSCodeSubFeature,
  pkgs,
  ...
}: let
  files = mkVSCodeSubFeature {
    enabled = true;
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

  text = mkVSCodeSubFeature {
    enabled = true;
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

  env = mkVSCodeSubFeature {
    enabled = true;
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

  license = mkVSCodeSubFeature {
    enabled = true;
    extensions = [
      #? License chooser and inserter
      "ultram4rine.vscode-choosealicense"
    ];
    userSettings = {
      "license.author" = "Craig 'Craole' Cole";
      "license.default" = "mit";
    };
  };

  spelling = mkVSCodeSubFeature {
    enabled = false;
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

  runners = mkVSCodeSubFeature {
    enabled = true;
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

  viewers = mkVSCodeSubFeature {
    enabled = false;
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

  keybindings = mkVSCodeSubFeature {
    enabled = true;
    extensions = [
      #? Restore familiar Windows keybindings
      "smcpeak.default-keys-windows"
    ];
    userSettings = {
      "vscode-default-keybindings.windowsKeybindings" = true;
    };
  };

  feeds = mkVSCodeSubFeature {
    enabled = true;
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

  spreadsheets = mkVSCodeSubFeature {
    enabled = true;
    extensions = ["mescius.spreadjs-xlsx-editor"];
    userSettings = {
      "spreadjs.ribbonMode" = "toolbar";
    };
  };

  integrations = mkVSCodeSubFeature {
    enabled = true;
    extensions = [];
    userSettings = {
      "atlascode.jira.enabled" = false;
    };
  };
in {
  name = "productivity";
  description = "Workflow, file management and utility extensions";
  default = true;
  feature = enabled:
    mkVSCodeFeature {
      inherit enabled pkgs inputs;
      extensions = flatten [
        files.extensions
        text.extensions
        env.extensions
        license.extensions
        spelling.extensions
        runners.extensions
        viewers.extensions
        keybindings.extensions
        feeds.extensions
        spreadsheets.extensions
        integrations.extensions
      ];
      userSettings = mkMerge [
        (files.userSettings or {})
        (text.userSettings or {})
        (env.userSettings or {})
        (license.userSettings or {})
        (spelling.userSettings or {})
        (runners.userSettings or {})
        (viewers.userSettings or {})
        (keybindings.userSettings or {})
        (feeds.userSettings or {})
        (spreadsheets.userSettings or {})
        (integrations.userSettings or {})
      ];
    };
}
