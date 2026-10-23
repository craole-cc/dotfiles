{
  mkGroup,
  mkEntry,
  ...
} @ args: let
in
  mkGroup {
    name = "terminal";
    description = "Terminal";
    default = true;
    features = [
      (mkEntry {
        userSettings = builtins.fromJSON ''
          {
            "terminal.integrated.allowMnemonics": true,
            "terminal.integrated.commandsToSkipShell": [
              "workbench.action.terminal.copySelection"
            ],
            "terminal.integrated.confirmOnExit": "never",
            "terminal.integrated.copyOnSelection": true,
            "terminal.integrated.enableImages": true,
            "terminal.integrated.enableMultiLinePasteWarning": "never",
            "terminal.integrated.hideOnStartup": "whenEmpty",
            "terminal.integrated.mouseWheelZoom": false,
            "terminal.integrated.rightClickBehavior": "copyPaste",
            "terminal.integrated.cursorBlinking": true,
            "terminal.integrated.cursorStyle": "block",
            "terminal.integrated.smoothScrolling": true,
            "terminal.integrated.stickyScroll.enabled": false,
            "terminal.integrated.tabs.location": "right",
            "terminal.integrated.defaultProfile.windows": "PowerShell",
            "terminal.integrated.profiles.windows": {
              "NixOS (WSL)": {
                "path": "''${env:windir}\\System32\\wsl.exe",
                "args": [
                  "-d",
                  "NixOS"
                ]
              },
              "Git Bash": {
                "source": "Git Bash"
              },
              "PowerShell": {
                "source": "PowerShell",
                "args": [
                  "-NoExit",
                  "-Command",
                  "& { $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User') }"
                ],
                "icon": "terminal-powershell"
              },
              "Windows PowerShell": {
                "path": "''${env:windir}\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
                "args": [
                  "-NoExit",
                  "-Command",
                  "& { $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User') }"
                ],
                "icon": "terminal-powershell"
              },
              "Nushell": {
                "path": "''${env:USERPROFILE}\\AppData\\Local\\Programs\\nu\\bin\\nu.exe"
              },
              "Command Prompt": {
                "path": [
                  "''${env:windir}\\Sysnative\\cmd.exe",
                  "''${env:windir}\\System32\\cmd.exe"
                ],
                "args": [],
                "icon": "terminal-cmd"
              }
            }
          }
        '';
        # Merged from keybindings.jsonc: TERMINAL
        keybindings = builtins.fromJSON ''
          [
            {
              "key": "ctrl+j",
              "command": "-workbench.action.togglePanel"
            },
            {
              "key": "ctrl+alt+`",
              "command": "workbench.action.terminal.kill"
            },
            {
              "key": "shift+escape",
              "command": "workbench.action.terminal.kill",
              "when": "terminalFocus"
            }
          ]
        '';
      })
    ];
  }
