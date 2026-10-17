{
  config,
  lix,
  inputs,
  pkgs,
  user,
  ...
}: let
  inherit (lix.lists.predicates) isIn;
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkEnable mkOption mkTrue;
  inherit (lix.sources.packages) pkgOf;
  inherit (lix.types.combinators) nullOr attrs;
  pkgType = nullOr lix.types.primitives.package;

  context = mkContext {
    inherit config;
    dom = "terminal";
    sub = "emulators";
    mod = "warp-terminal";
  };
  inherit (context) cfg mod;
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable {
        inherit context;
        condition = isIn [mod "warp-preview" "warp"] (with user; (
          (packages.terminal or []) ++ (applications.allowed or [])
        ));
      };
      enableAlias = mkTrue "${mod} command alias";
      alias = mkOption {
        description = "Alias (${mod}) for the executable";
        default = cfg.pkg.alias;
        readOnly = true;
        type = pkgType;
      };
      package = mkOption {
        inherit (cfg.pkg) description;
        default = cfg.pkg.package;
        type = pkgType;
      };
      pkg = mkOption {
        default = pkgOf {
          inherit inputs pkgs;
          input = "warp-terminal";
          alias =
            if cfg.enableAlias
            then mod
            else null;
          exe = "warp";
          required = true;
        };
        readOnly = true;
        type = attrs;
      };
    };
    outputs = {
      home.packages = with cfg; [package alias];
    };
  }
