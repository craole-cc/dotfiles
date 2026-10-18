{
  inputs,
  mkMerge,
  flatten,
  mkVSCodeFeature,
  mkVSCodeSubFeature,
  pkgs,
  ...
}: let
  docker = mkVSCodeSubFeature {
    enabled = false;
    extensions = [
      #? Docker file support and container management
      "ms-azuretools.vscode-docker"
    ];
  };

  sql = mkVSCodeSubFeature {
    enabled = false;
    extensions = [
      #? SQL client and query runner
      "mtxr.sqltools"
      #? SQLite driver for sqltools
      "mtxr.sqltools-driver-sqlite"
    ];
  };

  networking = mkVSCodeSubFeature {
    enabled = false;
    extensions = [
      #? Tailscale network integration
      "tailscale.vscode-tailscale"
    ];
  };
in {
  name = "infrastructure";
  description = "Docker, SQL, DevOps extensions";
  default = false;
  feature = enabled:
    mkVSCodeFeature {
      inherit enabled pkgs inputs;
      extensions = flatten [
        docker.extensions
        sql.extensions
        networking.extensions
      ];
      userSettings = mkMerge [
        (docker.userSettings or {})
        (sql.userSettings or {})
        (networking.userSettings or {})
      ];
    };
}
