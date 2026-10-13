{
  config,
  lix,
  pkgs,
  ...
}: let
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkEnable;

  context = mkContext {
    inherit config;
    dom = "interface";
    sub = "components";
    mod = "wallpaper";
  };
  inherit (context) ctx;
in
  mkConfig {
    inherit context;
    options.enable = mkEnable {
      inherit context;
      condition = ctx.wantsHyprland.condition;
    };
    outputs.home.packages = [pkgs.variety];
  }
