{
  config,
  apps,
  lib,
  lix,
  host,
  pkgs,
  ...
}: let
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkEnable;
  inherit (lix.lists.access) head;
  inherit (lib.modules) mkMerge;
  inherit (lix.lists.predicates) isIn;

  context = mkContext {
    inherit config;
    dom = "media";
    mod = "mpv";
  };
  inherit (context) cfg;

  terminal = head apps.terminal;
  args = context // {inherit lix pkgs terminal;};
in
  mkConfig {
    inherit context;
    options.enable = mkEnable {
      inherit context;
      condition = isIn "video" (host.functionalities or []);
    };
    outputs = {
      programs.mpv = mkMerge [
        {
          inherit (cfg) enable;
          scripts = import ./yazi.nix args;
        }
        (import ./bindings.nix)
        (import ./settings.nix {inherit pkgs;})
      ];
      home.packages = with pkgs; [ffmpeg-full];
    };
  }
