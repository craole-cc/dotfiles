{
  user,
  lix,
  cfg,
  context,
  mkEnable,
  requires,
  ...
}: let
  inherit (lix.lists.predicates) isIn;

  mod = "powershell";
  enable = cfg.powershell.enable;

  #? PowerShell LSP and debugger
  formatter = "ms-vscode.powershell";
in {
  inherit enable;
  options.powershell.enable = mkEnable {
    inherit context;
    condition = requires "powershell";
  };

  extensions = [formatter];

  settings = {
    "[powershell]" = {
      editor = {
        defaultFormatter = formatter;
        renderControlCharacters = true;
        renderWhitespace = "all";
        tabCompletion = "on";
      };
      files = {
        autoGuessEncoding = true;
        encoding = "utf8bom";
        trimTrailingWhitespace = true;
      };
    };
    powershell = {
      codeFormatting = {
        autoCorrectAliases = true;
        trimWhitespaceAroundPipe = true;
        useConstantStrings = true;
        useCorrectCasing = true;
        whitespaceBetweenParameters = true;
      };
      integratedConsole = {
        focusConsoleOnExecute = false;
        forceClearScrollbackBuffer = true;
        showOnStartup = false;
        suppressStartupBanner = true;
      };
    };
  };
}
