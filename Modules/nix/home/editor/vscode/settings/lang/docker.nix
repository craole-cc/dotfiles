{cfg, context, mkEnable, requires, ...}: {
  enable = cfg.docker.enable;
  options.docker.enable = mkEnable {
    inherit context;
    condition = requires "docker";
  };
  extensions = ["ms-azuretools.vscode-docker"];
}
