{
  config,
  lix,
  packages,
  pkgs,
  system,
  user,
  ...
}: let
  inherit (lix.lists.predicates) isIn;
  inherit (lix.sources.packages) pkgOf;
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkEnable;

  context = mkContext {
    inherit config;
    dom = "terminal";
    sub = "tools";
    mod = "warp-terminal";
  };
  isSelected =
    isIn ["warp-terminal" "warp-preview"]
    (user.packages.terminal or []);
  isAllowed =
    isIn ["warp-terminal" "warp-preview"]
    (user.applications.allowed or []);
  isEnabled = isSelected && isAllowed;
  warp = pkgOf {
    pkgs = packages.warp-terminal.${system};
    inherit system;
    target = "default";
    required = true;
  };
  warpTerminalCommand = pkgs.writeShellScriptBin "warp-terminal" ''
    exec ${warp.package}/bin/warp "$@"
  '';
in
  mkConfig {
    inherit context;
    options.enable = mkEnable {
      inherit context;
      condition = isEnabled;
    };
    outputs.home.file.".config/warp-terminal-preview/settings.toml".text = ''
      [session]
      startup_shell_override = "/run/current-system/sw/bin/bash"

      [terminal.input]
      honor_ps1 = true
    '';
    outputs.home.packages = [warp.package warpTerminalCommand];
  }
