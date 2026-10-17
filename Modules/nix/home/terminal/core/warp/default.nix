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
  inherit (lix.types.combinators) nullOr attrs;
  pkgType = nullOr lix.types.primitives.package;

  context = mkContext {
    inherit config;
    dom = "terminal";
    sub = "emulators";
    mod = "warp-terminal";
  };
  inherit (context) cfg mod;
  name = mod;
  path = cfg.pkg.paths.executable;
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable {
        inherit context;
        condition = isIn [name "warp-preview" "warp"] (with user; (
          (packages.terminal or []) ++ (applications.allowed or [])
        ));
      };
      package = mkOption {
        inherit (cfg.pkg) description;
        default = cfg.pkg.package;
        type = pkgType;
      };
      symLink = mkOption {
        default = pkgs.linkFarm name [{inherit name path;}];
        readOnly = true;
        type = pkgType;
      };
      pkg = mkOption {
        default = pkgOf {
          inherit inputs pkgs;
          input = "warp-terminal";
          exe = "warp";
          required = true;
        };
        readOnly = true;
        type = attrs;
      };
    };
    outputs = {
      home.packages = with cfg; [package symLink];
    };
  }
