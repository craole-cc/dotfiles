{
  config,
  lix,
  user,
  inputs,
  pkgs,
  style,
  ...
}: let
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.modules.construction) mkConfig mkContext mkForce;
  inherit (lix.options.construction) mkEnable mkOption;
  inherit (lix.styles.icons.types) icon;

  context = mkContext {
    inherit config;
    dom = "interface";
    sub = "panels";
    mod = "dms-shell";
  };
  inherit (context) cfg ctx;

  inherit (import ./packages.nix {inherit inputs lix pkgs;}) tools bins package;
  themes = import ./themes.nix {inherit config lix;};
  templates = import ./templates.nix {inherit config lix pkgs style user;};
  sync = import ./sync.nix {inherit bins config lix pkgs style themes;};
  activation = import ./activation.nix {inherit bins config inputs lix style templates themes user;};
  pluginSetup = import ./plugins {inherit bins config inputs lix pkgs;};
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable ({inherit context;} // ctx.wantsDmsShell);
      icons = mkOption {
        description = "Resolved DMS desktop icon contract";
        default = themes.icons.resolved;
        type = icon.home;
        readOnly = true;
      };
    };

    outputs = {
      programs.dank-material-shell = {
        inherit (cfg) enable;
        inherit (pluginSetup) plugins;
        inherit package;
        quickshell = {inherit (tools.quickshell) package;};
        systemd = {
          enable = true;
          target = "graphical-session.target";
        };
      };

      xdg = {
        configFile = mergeSafe [
          pluginSetup.files
          (with templates.foot.theme.mutagen; {"${target}" = {inherit source;};})
        ];
        inherit (themes) dataFile;
      };

      gtk = {
        enable = mkForce true;
        iconTheme = mkForce {inherit (cfg.icons) package name;};
      };

      home = {
        packages = [themes.resolved.cursors.dark.package themes.resolved.cursors.light.package] ++ pluginSetup.packages;
        sessionVariables.QS_ICON_THEME = themes.icons.dark.theme;
        activation = {
          configureDmsTheme = activation;
          configureDmsPlugins = pluginSetup.activation;
          migrateDmsPlugins = pluginSetup.migration;
        };
      };

      systemd = import ./services.nix {inherit config lix sync;};
    };
  }
