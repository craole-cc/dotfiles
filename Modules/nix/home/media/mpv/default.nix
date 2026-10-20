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
  inherit (lib.modules) mkMerge;
  inherit (lix.lists.predicates) isIn;

  context = mkContext {
    inherit config;
    dom = "media";
    mod = "mpv";
  };
  isAllowed = isIn "video" (host.functionalities or []);
  primaryTerminal = apps.legacy.terminal.primary or null;
  yaziScripts =
    if primaryTerminal == null
    then []
    else [
      (import ./yazi.nix {
        inherit pkgs;
        terminal = primaryTerminal;
      })
    ];
in
  mkConfig {
    inherit context;
    options.enable = mkEnable {
      inherit context;
      condition = isAllowed;
    };
    outputs = {
      programs.mpv = mkMerge [
        {
          enable = true;
          scripts = yaziScripts;
        }
        (import ./bindings.nix)
        (import ./settings.nix {inherit pkgs;})
      ];
      home.packages = with pkgs; [ffmpeg-full];
    };
  }
