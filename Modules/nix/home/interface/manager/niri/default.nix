{
  config,
  host,
  keyboard,
  lib,
  lix,
  pkgs,
  apps,
  user,
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
  userInterface = lib.attrsets.removeAttrs (user.interface or {}) ["keyboard"];
  niriInterface = (lix.schema.ui.mkUI {
    inherit host;
    user = user // {
      interface = userInterface // {desktops = ["niri"];};
    };
  }).keyboard;
  niriKeyboard = lix.schema.io.mergeKeyboards [keyboard niriInterface];
  niriPackage = config.programs.niri.package;
  scratchpads = import ./scratchpads.nix {
    actions = actions;
    apps = apps;
    keyboard = niriKeyboard;
    inherit lib niriPackage pkgs;
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
            keyboard = niriKeyboard;
            inherit actions;
          }) // scratchpads.binds;
          workspaces = scratchpads.workspaces;
          window-rules = scratchpads.window-rules;
        };
      };
      home.packages = scratchpads.packages;
    };
  }
