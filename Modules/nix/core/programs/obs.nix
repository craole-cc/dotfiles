{
  config,
  host,
  lix,
  ...
}: let
  context = mkContext {
    inherit config;
    dom = "programs";
    mod = "obs-studio";
  };
  inherit (context) cfg mod;

  inherit (lix.modules.construction) mkConfig mkContext mkIf;
  inherit (lix.lists.predicates) elem;
  inherit (lix.options.construction) literalExpression mkEnable mkOption;
  inherit (lix.types.combinators) listOf;
  inherit (lix.types.primitives) package;

  hw = host.hardware;
  defaultPlugins = [];
  # CachyOS can supply this module itself; a second copy collides at assembly.
  kernelHasVirtualCamera = elem (config.boot.kernelPackages.kernel.config.CONFIG_V4L2_LOOPBACK or "n") ["m" "y"];
  useKernelVirtualCamera = cfg.enable && cfg.enableVirtualCamera && kernelHasVirtualCamera;
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable {
        description = "OBS Studio";
        # TODO: Restore camera-based OBS enablement when OBS is needed again.
        # condition = hw.hasVideoCam;
        condition = false;
      };
      enableVirtualCamera = mkEnable {
        description = "OBS virtual camera";
        condition = hw.hasVideoCam;
      };
      plugins = mkOption {
        description = "Optional plugins for OBS.";
        default = defaultPlugins;
        defaultText = literalExpression "default OBS plugin set, plus wlrobs when interface.displayProtocol == \"wayland\"";
        type = listOf package;
      };
    };
    outputs = {
      programs.${mod} = {
        inherit (cfg) enable plugins;
        enableVirtualCamera = cfg.enableVirtualCamera && !kernelHasVirtualCamera;
      };
      boot = mkIf useKernelVirtualCamera {
        kernelModules = ["v4l2loopback"];
        extraModprobeConfig = ''
          options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
        '';
      };
      security.polkit.enable = mkIf useKernelVirtualCamera true;
    };
  }
