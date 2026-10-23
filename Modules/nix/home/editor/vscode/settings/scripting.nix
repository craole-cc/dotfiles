{
  inputs,
  mkMerge,
  flatten,
  mkVSCodeFeature,
  mkVSCodeSubFeature,
  pkgs,
  ...
}: let
  python = mkVSCodeSubFeature {
    enabled = false;
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

  nushell = mkVSCodeSubFeature {
    enabled = false;
    extensions = [
      #? Nushell language support
      "thenuprojectcontributors.vscode-nushell-lang"
    ];
  };

  powershell = mkVSCodeSubFeature {
    enabled = true;
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

  ruby = mkVSCodeSubFeature {
    enabled = true;
    extensions = [];
    userSettings = {
      "rubyLsp.enableExperimentalFeatures" = true;
    };
  };
in {
  name = "scripting";
  description = "Python, Nushell, PowerShell extensions";
  default = true;
  feature = enabled:
    mkVSCodeFeature {
      inherit enabled pkgs inputs;
      extensions = flatten [
        python.extensions
        nushell.extensions
        powershell.extensions
        ruby.extensions
      ];
      userSettings = mkMerge [
        (python.userSettings or {})
        (nushell.userSettings or {})
        (powershell.userSettings or {})
        (ruby.userSettings or {})
      ];
      keybindings = flatten (map (feature: feature.keybindings or []) [python nushell powershell ruby]);
    };
}
