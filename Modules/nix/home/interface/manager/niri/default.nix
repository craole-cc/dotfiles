{
  config,
  host,
  keyboard,
  lib,
  lix,
  pkgs,
  apps,
  ...
}:
let
  context = mkContext {
    inherit config host;
    dom = "interface";
    sub = "managers";
    mod = "niri";
  };
  inherit (context) cfg ctx;

  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkEnable;
  inherit (lix.schema.io) mkNiriKeybindings;
  inherit (lib.modules) mkIf;
  niriPackage = config.programs.niri.package;
  scratchpads = import ./scratchpads.nix {
    inherit actions apps keyboard lib niriPackage pkgs;
  };
  actions = config.lib.niri.actions;
in
  mkConfig {
    inherit context;
    options.enable = mkEnable ({inherit context;} // ctx.wantsNiri);
    outputs = mkIf cfg.enable {
      programs.niri = {
        enable = true;
        package = pkgs.niri;
        settings = {
          binds = (mkNiriKeybindings {
            inherit keyboard actions;
          }) // scratchpads.binds;
          workspaces = scratchpads.workspaces;
          window-rules = scratchpads.window-rules;
        };
      };
      home.packages = scratchpads.packages;
    };
  }
