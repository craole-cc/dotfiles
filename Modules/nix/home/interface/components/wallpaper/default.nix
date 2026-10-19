{
  config,
  lix,
  inputs,
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
  inherit (lix.applications.construction) mkScriptWrapper;
  inherit (lix.attrsets.access) attrValues;
  inherit (lix.attrsets.construction) genAttrs mapAttrs optionalAttrs;
  inherit (lix.filesystem.construction) concatPath;
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkEnable;
  inherit (lix.lists.predicates) isIn;
  inherit (lix.lists.construction) optional;
  inherit (lix.sources.packages) pkgsFrom;

  tool = let
    resolved = pkgsFrom {
      inherit inputs pkgs;
      sources = optionalAttrs cfg.hyprpaper.enable {hyprpaper = null;};
    };
  in {inherit (resolved) packages;};
in
  mkConfig {
    inherit context;
    imports = [(import ./variety {wallpaper = context;})];

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
      # variety.enable = mkEnable {
      #   inherit context;
      #   condition =
      #     cfg.enable
      #     && isIn "variety" (user.applications.wallpaper or []);
      # };
    };

    outputs = {
      home = {
        inherit (tool) packages;
      };
    };
  }
