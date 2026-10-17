{
  lix,
  config,
  host,
  lib,
  top,
  ...
}: let
  inherit (lix.modules.core.staging) mkStaged;
  inherit (config.dots.interface) display desktop;
  cfgEnabled = desktop.environment == "gnome" && display.protocol == "xserver";
  gpu = host.hardware.gpu or {};
  primaryGpu = if (gpu.primary or null) == null then {} else gpu.primary;
  secondaryGpu = if (gpu.secondary or null) == null then {} else gpu.secondary;
  nvidiaEnabled =
    config.hardware.nvidia.modesetting.enable
    || (primaryGpu.brand or "") == "nvidia"
    || (secondaryGpu.brand or "") == "nvidia";
  payload = {
    services.xserver = {
      enable = true;
      videoDrivers =
        if nvidiaEnabled
        then ["nvidia"]
        else [];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
in {
  config = lib.mkMerge (mkStaged {
    inherit top payload;
    condition = cfgEnabled;
  });
}
