{
  config,
  inputs,
  lix,
  pkgs,
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
  isAllowed = isIn "warp-terminal" (user.applications.allowed or []);
  warp = pkgOf {
    inherit inputs pkgs;
    input = "terminalWarp";
    required = true;
  };
in
  mkConfig {
    inherit context;
    options.enable = mkEnable {
      inherit context;
      condition = isAllowed;
    };
    outputs.home.file.".config/warp-terminal/settings.toml".text = ''
      [session]
      startup_shell_override = "/run/current-system/sw/bin/bash"
    '';
    outputs.home.packages = [warp.package];
  }
