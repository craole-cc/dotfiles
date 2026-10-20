{
  config,
  lix,
  inputs,
  pkgs,
  user,
  ...
}: let
  inherit (lix.attrsets.aggregation) recursiveUpdate;
  inherit (lix.lists.predicates) isIn;
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkEnable mkOption mkTrue;
  inherit (lix.sources.packages) pkgOf;
  inherit (lix.strings.transformation) replaceStrings;
  inherit (lix.types.combinators) nullOr attrs;
  pkgType = nullOr lix.types.primitives.package;

  system = pkgs.stdenv.hostPlatform.system;
  warpInput = inputs."warp-terminal";
  warpPackage = warpInput.packages.${system}.default.overrideAttrs (
    previous: let
      release = replaceStrings [".preview."] [".preview_"] previous.version;
    in {
      # The rolling download can advance before the input's version and hash do.
      src = pkgs.fetchurl {
        inherit (previous.src) name;
        hash = previous.src.outputHash;
        url = "https://releases.warp.dev/preview/v${release}/warp-terminal-preview_${previous.version}_${
          if system == "aarch64-linux"
          then "arm64"
          else "amd64"
        }.deb";
      };
    }
  );

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
          inherit pkgs;
          inputs = recursiveUpdate inputs {
            "warp-terminal".packages.${system}.default = warpPackage;
          };
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
