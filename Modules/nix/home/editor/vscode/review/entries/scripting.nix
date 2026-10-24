{
  mkGroup,
  mkEntry,
  ...
}: let
  python = mkEntry {
    enable = false;
    extensions = [
      #? Python LSP and tooling
      "ms-python.python"
      #? Python debugger
      "ms-python.debugpy"
      #? fast Python type checker
      "ms-python.vscode-pylance"
      #? Ruff linter/formatter
      "charliermarsh.ruff"
    ];
    userSettings = {
      "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
      "python.analysis.typeCheckingMode" = "basic";
    };
  };

  nushell = mkEntry {
    enable = false;
    extensions = [
      #? Nushell language support
      "thenuprojectcontributors.vscode-nushell-lang"
    ];
  };

  powershell = mkEntry {
    enable = true;
    extensions = [
      #? PowerShell LSP and debugger
      "ms-vscode.powershell"
    ];
    userSettings = {
      "[powershell]" = {
        "editor.defaultFormatter" = "ms-vscode.powershell";
        "editor.renderControlCharacters" = true;
        "editor.renderWhitespace" = "all";
        "editor.tabCompletion" = "on";
        "files.autoGuessEncoding" = true;
        "files.encoding" = "utf8bom";
        "files.trimTrailingWhitespace" = true;
      };
      "powershell.codeFormatting.autoCorrectAliases" = true;
      "powershell.codeFormatting.trimWhitespaceAroundPipe" = true;
      "powershell.codeFormatting.useConstantStrings" = true;
      "powershell.codeFormatting.useCorrectCasing" = true;
      "powershell.codeFormatting.whitespaceBetweenParameters" = true;
      "powershell.integratedConsole.focusConsoleOnExecute" = false;
      "powershell.integratedConsole.forceClearScrollbackBuffer" = true;
      "powershell.integratedConsole.showOnStartup" = false;
      "powershell.integratedConsole.suppressStartupBanner" = true;
    };
  };

  ruby = mkEntry {
    enable = true;
    extensions = [];
    userSettings = {
      "rubyLsp.enableExperimentalFeatures" = true;
    };
  };
in {entries = {inherit python nushell powershell ruby;};}
