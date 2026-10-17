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
  inherit (lix.options.construction) mkEnable mkOption;
  pkgType = with lix.types; combinators.nullOr primitives.package;

  context = mkContext {
    inherit config;
    dom = "terminal";
    sub = "emulators";
    mod = "warp-terminal";
  };
  inherit (context) cfg mod;

  tool = pkgOf {
    inherit inputs pkgs;
    input = "warp-terminal";
    target = "default";
    exe = "warp";
    required = true;
  };
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable {
        inherit context;
        condition = isIn [mod "warp-preview"] (with user; (
          (packages.terminal or []) ++ (applications.allowed or [])
        ));
      };
      package = mkOption {
        description = "The Warp Terminal package to use.";
        default = tool.package;
        type = pkgType;
      };
      alias = mkOption {
        default = pkgs.writeShellScriptBin mod ''exec ${tool.exe} "$@"'';
        type = pkgType;
      };
    };
    outputs = {
      home.packages = with cfg; [package alias];
    };
  }
