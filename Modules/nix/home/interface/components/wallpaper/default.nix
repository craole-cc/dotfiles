{
  config,
  entryAfter,
  lix,
  inputs,
  paths,
  pkgs,
  user,
  ...
}: let
  context = mkContext {
    inherit config;
    dom = "interface";
    sub = "components";
    mod = "wallpaper";
  };
  inherit (context) cfg ctx;
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkEnable;
  inherit (lix.sources.packages) pkgsFrom;

  tool = let
    resolved = pkgsFrom {
      inherit inputs pkgs;
      sources = optionalAttrs cfg.hyprpaper.enable {hyprpaper = null;};
    };
  in {inherit (resolved) packages;};

  args = {
    inherit config entryAfter inputs lix paths pkgs user;
    wallpaper = context;
  };
in
  {imports = [(import ./variety args)];}
  // mkConfig {
    inherit context;

    options = {
      enable = mkEnable {
        inherit context;
        condition = with ctx; windowManagers != null || desktopEnvironments != null;
      };
      hyprpaper.enable = mkEnable {
        inherit context;
        condition =
          cfg.enable
          && ctx.wantsHyprland.condition;
      };
    };

    outputs = {
      home = {
        inherit (tool) packages;
      };
    };
  }
