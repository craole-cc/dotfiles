_: {
  userSettings = {
    # General
    "license.author" = "Craig 'Craole' Cole";
    "license.default" = "mit";
    "extensions.ignoreRecommendations" = true;
    "update.mode" = "manual";
    "security.workspace.trust.untrustedFiles" = "open";
    "diffEditor.codeLens" = true;
    "diffEditor.ignoreTrimWhitespace" = false;

    # Copilot
    "github.copilot.enable" = {
      "*" = true;
      "plaintext" = false;
      "markdown" = false;
      "scminput" = false;
      "nix" = true;
      "shellscript" = true;
      "rust" = false;
      "powershell" = false;
    };
    "github.copilot.chat.codesearch.enabled" = true;
    "github.copilot.chat.editor.temporalContext.enabled" = true;
    "github.copilot.nextEditSuggestions.enabled" = true;
    "github.copilot.nextEditSuggestions.eagerness" = "low";

    # Codeium
    "codeium.disableSupercomplete" = true;
    "codeium.enableSearch" = true;
    "codeium.enableConfig" = {
      "*" = true;
      "nix" = true;
      "jsonc" = true;
      "just" = true;
      "markdown" = true;
      "typst" = true;
      "cypher" = true;
    };

    # LLDB
    "lldb.suppressUpdateNotifications" = true;
    "lldb.showDisassembly" = "auto";
    "lldb.dereferencePointers" = true;
    "lldb.consoleMode" = "commands";

    # Direnv
    "direnv.restart.automatic" = true;

    # Dotenv
    "dotenv.enableAutocloaking" = false;

    # Redhat
    "redhat.telemetry.enabled" = false;

    # Remote
    "remote.autoForwardPortsSource" = "hybrid";
    "remote.SSH.remotePlatform" = {
      "dbook.deer-iguana.ts.net" = "linux";
      "delle.deer-iguana.ts.net" = "linux";
    };

    # Misc
    "atlascode.jira.enabled" = false;
    "settingsSync.ignoredExtensions" = [
      "jnoortheen.nix-ide"
      "mkhl.direnv"
      "ms-vscode-remote.remote-wsl"
      "constneo.vscode-nushell-format"
      "ms-edgedevtools.vscode-edge-devtools"
    ];
    "continue.telemetryEnabled" = false;
    "continue.disableQuickFix" = true;
    "continue.enableTabAutocomplete" = true;
    "continue.showInlineTip" = false;
    "geminicodeassist.chat.defaultCodeBlockDisplay" = "Expanded";
    "geminicodeassist.inlineSuggestions.enableAuto" = true;
    "geminicodeassist.updateChannel" = "Insiders";
    "harper.dialect" = "British";
    "harper.workspaceDictPath" = ".harper-dictionary.txt";
    "harper.excludePatterns" = [];
    "harper.linters.Dashes" = false;
    "harper.linters.NumericRangeEnDash" = false;
    "harper.linters.OxfordComma" = false;
    "harper.linters.SentenceCapitalization" = false;
    "typos.diagnosticSeverity" = "Hint";
    "chat.experimental.stickyScroll.enabled" = false;
    "chat.tools.terminal.autoApprove" = {
      awk = true;
      cksum = true;
      command = true;
      nix = true;
      printf = true;
      zig = true;
    };
    "chat.viewSessions.orientation" = "stacked";
    "vs-browser.favourites.list" = {
      "http://127.0.0.1:3000" = "http://127.0.0.1:3000";
      "http://localhost" = "http://localhost";
    };
    "vs-browser.link.enabled" = true;
    "vs-browser.link.openWith" = "ask";
    "vs-browser.localProxyServer.cookieDomainRewrite" = true;
    "vs-browser.localProxyServer.enabled" = true;
    "vs-browser.localProxyServer.forceLocation" = true;
    "vs-browser.reload.autoReloadDurationEnabled" = false;
    "vs-browser.reload.autoReloadDurationTime" = 15000;
    "vs-browser.reload.onSave" = false;
    "vs-browser.url" = "http://127.0.0.1:3000";
    "rss.accounts" = {
      "fb0e47b0-9982-11ef-a698-3778cde2492f" = {
        name = "Default";
        type = "local";
        feeds = [];
      };
    };
    "spreadjs.ribbonMode" = "toolbar";
    "vscode-default-keybindings.windowsKeybindings" = true;
    "rubyLsp.enableExperimentalFeatures" = true;
    "lintRunner.tools" = {
      "shellcheck" = {
        "kind" = "diagnostic";
        "command" = "shellcheck";
        "args" = [
          "--enable=all"
          "--format=gcc"
          "\${file}"
        ];
        "successExitCodes" = [
          0
          1
        ];
        "parser" = {
          "flags" = "gm";
          "pattern" = "^.+?:(?<line>\\d+):(?<col>\\d+): (?<severity>error|warning|note): (?<message>.+)$";
        };
      };
      "statix" = {
        "kind" = "diagnostic";
        "command" = "statix";
        "args" = [
          "check"
          "--format"
          "errfmt"
          "\${file}"
        ];
        "successExitCodes" = [
          0
          1
        ];
        "parser" = {
          "flags" = "gm";
          "pattern" = "^.+?>(?<line>\\d+):(?<col>\\d+):[WE]:(?<code>\\d+):(?<message>.+)$";
        };
      };
    };
    "lintRunner.targets" = [
      {
        "name" = "Nix";
        "match" = {
          "languages" = [
            "nix"
          ];
          "files" = [
            "**/*.nix"
          ];
        };
        "onOpen" = {
          "strategy" = "sequence";
          "tools" = [
            "statix"
          ];
        };
        "onSave" = {
          "strategy" = "sequence";
          "tools" = [
            "statix"
          ];
        };
        "manual" = {
          "strategy" = "sequence";
          "tools" = [
            "statix"
          ];
        };
      }
      {
        "name" = "Shell";
        "match" = {
          "languages" = [
            "shellscript"
          ];
        };
        "onOpen" = {
          "strategy" = "sequence";
          "tools" = [
            "shellcheck"
          ];
        };
        "onSave" = {
          "strategy" = "sequence";
          "tools" = [
            "shellcheck"
          ];
        };
      }
    ];
  };
}
