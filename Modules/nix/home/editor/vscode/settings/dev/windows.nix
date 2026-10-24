_: {
  name = "windows";
  description = "Terminal on Windows";
  settings = {
    "terminal.integrated.defaultProfile.windows" = "PowerShell";
    "terminal.integrated.profiles.windows" = {
      "NixOS (WSL)" = {
        "path" = "''${"env:windir"}\\System32\\wsl.exe";
        "args" = ["-d" "NixOS"];
      };
      "Git Bash" = {
        "source" = "Git Bash";
      };
      "PowerShell" = {
        "source" = "PowerShell";
        "args" = [
          "-NoExit"
          "-Command"
          "& { $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User') }"
        ];
        "icon" = "terminal-powershell";
      };
      "Windows PowerShell" = {
        "path" = "''${"env:windir"}\\System32\\WindowsPowerShell\\v1.0\\powershell.exe";
        "args" = [
          "-NoExit"
          "-Command"
          "& { $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User') }"
        ];
        "icon" = "terminal-powershell";
      };
      "Nushell" = {
        "path" = "''${"env:USERPROFILE"}\\AppData\\Local\\Programs\\nu\\bin\\nu.exe";
      };
      "Command Prompt" = {
        "path" = [
          "''${"env:windir"}\\Sysnative\\cmd.exe"
          "''${"env:windir"}\\System32\\cmd.exe"
        ];
        "args" = [];
        "icon" = "terminal-cmd";
      };
    };
  };

  keybindings = [];
}
