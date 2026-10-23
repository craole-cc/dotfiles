{
  mkGroup,
  mkEntry,
  ...
}: let
  docker = mkEntry {
    enable = false;
    extensions = [
      #? Docker file support and container management
      "ms-azuretools.vscode-docker"
    ];
  };

  sql = mkEntry {
    enable = false;
    extensions = [
      #? SQL client and query runner
      "mtxr.sqltools"
      #? SQLite driver for sqltools
      "mtxr.sqltools-driver-sqlite"
    ];
  };

  networking = mkEntry {
    enable = false;
    extensions = [
      #? Tailscale network integration
      "tailscale.vscode-tailscale"
    ];
  };
in {entries = {inherit docker sql networking;};}
