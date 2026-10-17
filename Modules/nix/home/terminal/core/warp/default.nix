{
  config,
  lix,
  inputs,
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
    sub = "emulators";
    mod = "warp-terminal";
  };
  isSelected =
    isIn ["warp-terminal" "warp-preview"]
    (user.packages.terminal or []);
  isAllowed =
    isIn ["warp-terminal" "warp-preview"]
    (user.applications.allowed or []);
  isEnabled = isSelected && isAllowed;

  tool = pkgOf {
    inherit inputs pkgs;
    input = "warp-terminal";
    required = true;
  };
  exe = pkgs.writeShellScriptBin "warp-terminal" ''
    exec ${tool.exe} "$@"
  '';
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable {
        inherit context;
        condition = isEnabled;
      };
    };
    outputs = {
      home = {
        packages = [tool.package exe];
      };
    };
  }
