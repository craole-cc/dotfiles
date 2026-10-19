{
  config,
  lix,
  paths,
  pkgs,
  ...
}:
let
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.applications.construction) mkScriptWrappers;
  inherit (lix.options.construction) mkEnable;

  context = mkContext {
    inherit config;
    dom = "interface";
    sub = "components";
    mod = "wallpaper";
  };
  inherit (context) cfg ctx;
  wallpaperLib = paths.store.lib.sh + "/wallpaper";
  wallpaperCommands = mkScriptWrappers {
    inherit pkgs;
    scripts = {
      variety_next = "${wallpaperLib}/variety_next";
      variety_previous = "${wallpaperLib}/variety_previous";
      variety_love = "${wallpaperLib}/variety_love";
    };
  };
in
{
  imports = [ ./variety ];
}
// mkConfig {
  inherit context;
  options.enable = mkEnable {
    inherit context;
    condition = ctx.wantsHyprland.condition;
  };

  outputs = {
    # Variety installs its profile-aware package through its Home Manager
    # module, so don't also install pkgs.variety here.
    programs.variety.enable = cfg.enable;
    home.packages = [ pkgs.hyprpaper ] ++ wallpaperCommands;
  };
}
