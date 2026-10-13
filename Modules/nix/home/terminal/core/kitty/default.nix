{
  config,
  lib,
  lix,
  pkgs,
  user,
  ...
}: let
  inherit (lix.applications.generators) userApplicationConfig;
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkTrue;

  context = mkContext {
    inherit config;
    dom = "terminal";
    sub = "emulators";
    mod = "kitty";
  };

  dmsEnabled = context.wantsDmsShell.condition;

  resolved = userApplicationConfig {
    inherit context user pkgs;
    extraProgramConfig = {
      settings = {
        background_opacity = 0.97;
        copy_on_select = "no";
        confirm_os_window_close = 0;
        remember_window_size = false;
      };

      # DMS owns the generated color files. Home Manager only includes them
      # when DMS is the active shell; without DMS Kitty keeps its own defaults.
      extraConfig = lib.optionalString dmsEnabled ''
        include dank-tabs.conf
        include dank-theme.conf
      '';
    };
  };
in
  mkConfig {
    inherit context;
    # options.enable = mkTrue "Kitty Terminal Emulator";
    # options.enable = mkEnable {
    #   inherit context;
    #   condition = resolved.enable;
    # };
    outputs = {inherit (resolved) programs home;};
  }
