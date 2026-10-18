{
  config,
  lib,
  lix,
  user,
  pkgs,
  ...
}: let
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkEnable;
  inherit (lib.modules) mkMerge;
  inherit (lix.applications.generators) userApplicationConfig;

  context = mkContext {
    inherit config;
    dom = "editor";
    mod = "helix";
    kind = "editor";
  };

  session = import ./session {
    inherit config lix pkgs;
    name = (lix.applications.registry.resolve {value = "helix";}).launch.scratchpad;
  };

  resolved = userApplicationConfig {
    inherit context user pkgs;
    category = "tty";
    resolutionHints = [
      "hx"
      "helix"
      "helix-editor"
    ];
    requiresWayland = true;
    extraPackages = [session];
    extraProgramConfig = mkMerge [
      (import ./editor.nix)
      (import ./keybindings.nix {inherit pkgs lix;})
      (import ./languages.nix)
      # (import ./themes.nix)
    ];
    debug = false;
  };
in
  mkConfig {
    inherit context;
    options.enable = mkEnable {
      inherit context;
      condition = resolved.enable;
    };
    outputs = {inherit (resolved) home programs;};
  }
