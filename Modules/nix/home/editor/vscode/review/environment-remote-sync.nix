{
  mkGroup,
  mkEntry,
  ...
} @ args: let
  infrastructure = import ./entries/infrastructure.nix args;
  nix = import ./entries/nix.nix args;
  productivity = import ./entries/productivity.nix args;
in
  mkGroup {
    name = "environment-remote-sync";
    description = "Environment, Remote & Sync";
    default = true;
    features =
      [
        (mkEntry {
          userSettings = builtins.fromJSON ''
            {
              "direnv.restart.automatic": true,
              "dotenv.enableAutocloaking": false,
              "remote.autoForwardPortsSource": "hybrid",
              "remote.SSH.remotePlatform": {
                "dbook.deer-iguana.ts.net": "linux",
                "delle.deer-iguana.ts.net": "linux"
              },
              "settingsSync.ignoredExtensions": [
                "constneo.vscode-nushell-format",
                "jnoortheen.nix-ide",
                "mkhl.direnv",
                "ms-edgedevtools.vscode-edge-devtools",
                "ms-vscode-remote.remote-wsl"
              ]
            }
          '';
        })
      ]
      ++ map (entry:
        entry
        // {
          userSettings = {};
          keybindings = [];
        }) [
        productivity.entries.env
        infrastructure.entries.networking
        nix.entries.direnv
      ];
  }
