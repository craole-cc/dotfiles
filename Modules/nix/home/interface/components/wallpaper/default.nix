{
  config,
  lix,
  paths,
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
  variety = import ./variety {inherit lix paths;};
in
  mkConfig {
    inherit context;
    options.enable = mkEnable {
      inherit context;
      condition = ctx.wantsHyprland.condition;
    };

    outputs = {
      # Home-manager module in ./variety (programs.variety.*). It installs a
      # profile-aware `variety` wrapper, so pkgs.variety is no longer listed
      # here: both on the profile would collide on bin/variety.
      home.packages = with pkgs; [hyprpaper];
    };
  }
