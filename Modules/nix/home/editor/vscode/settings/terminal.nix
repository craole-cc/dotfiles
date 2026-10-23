{mkDefault, ...}: {
  userSettings = {
    "terminal.integrated.fontFamily" = "'Maple Mono NF', 'Lilex Nerd Font', monospace";
    "terminal.integrated.fontSize" = mkDefault 18;
    "terminal.integrated.fontWeight" = 500;
    "terminal.integrated.fontLigatures.enabled" = true;
    "terminal.integrated.letterSpacing" = 0;
    "terminal.integrated.lineHeight" = 1.2;

    "terminal.integrated.allowMnemonics" = true;
    "terminal.integrated.commandsToSkipShell" = ["workbench.action.terminal.copySelection"];
    "terminal.integrated.confirmOnExit" = "never";
    "terminal.integrated.copyOnSelection" = true;
    "terminal.integrated.cursorBlinking" = true;
    "terminal.integrated.cursorStyle" = "block";
    "terminal.integrated.enableImages" = true;
    "terminal.integrated.enableMultiLinePasteWarning" = "never";
    "terminal.integrated.hideOnStartup" = "whenEmpty";
    "terminal.integrated.mouseWheelZoom" = false;
    "terminal.integrated.rightClickBehavior" = "copyPaste";
    "terminal.integrated.smoothScrolling" = true;
    "terminal.integrated.stickyScroll.enabled" = false;
    "terminal.integrated.tabs.location" = "right";
    "terminal.integrated.defaultProfile.windows" = "PowerShell";
    "terminal.integrated.profiles.windows" = {
      "NixOS (WSL)" = {
        path = "\${env:windir}\\System32\\wsl.exe";
        args = ["-d" "NixOS"];
      };
      "Git Bash" = {source = "Git Bash";};
      "PowerShell" = {
        source = "PowerShell";
        args = [
          "-NoExit"
          "-Command"
          "& { $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User') }"
        ];
        icon = "terminal-powershell";
      };
      "Windows PowerShell" = {
        path = "\${env:windir}\\System32\\WindowsPowerShell\\v1.0\\powershell.exe";
        args = [
          "-NoExit"
          "-Command"
          "& { $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User') }"
        ];
        icon = "terminal-powershell";
      };
      "Nushell" = {path = "\${env:USERPROFILE}\\AppData\\Local\\Programs\\nu\\bin\\nu.exe";};
      "Command Prompt" = {
        path = [
          "\${env:windir}\\Sysnative\\cmd.exe"
          "\${env:windir}\\System32\\cmd.exe"
        ];
        args = [];
        icon = "terminal-cmd";
      };
    };
  };
  keybindings = [
    {
      "key" = "ctrl+alt+`";
      "command" = "workbench.action.terminal.kill";
    }
    {
      "key" = "shift+escape";
      "command" = "workbench.action.terminal.kill";
      "when" = "terminalFocus";
    }
  ];
}
