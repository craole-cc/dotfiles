{
  config,
  inputs,
  lix,
  pkgs,
  user,
  ...
}: let
  inherit (lix.lists.predicates) isIn;
  inherit (lix.sources.packages) pkgsFrom;
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
  warp = pkgsFrom {
    inherit inputs pkgs;
    sources.warp = "warp-terminal";
  };
in
  mkConfig {
    inherit context;
    options.enable = mkEnable {
      inherit context;
      condition = isEnabled;
    };
    outputs.home = {
      packages = warp.packages;
    };
  }
