{
  config,
  lix,
  user,
  inputs,
  pkgs,
  style,
  ...
}: let
  context = mkContext {
    inherit config;
    dom = "interface";
    sub = "panels";
    mod = "dms-shell";
  };
  inherit (context) cfg ctx;
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.modules.construction) mkConfig mkContext mkForce;
  inherit (lix.options.construction) mkEnable mkOption;
  inherit (lix.styles.icons.types) icon;
  inherit (lix.filesystem.primitives) concat;

  args = {
    inherit bins config inputs lix pkgs style themes user;
    inherit (inputs.home-manager.lib.hm.dag) entryAfter;
    configHome =
      config.xdg.configHome or (concat {
        root = user.home;
        stem = ".config";
      });

    stateHome =
      config.xdg.stateHome or (concat {
        root = user.home;
        stem = ".local/state";
      });
  };

  inherit (import ./packages.nix args) tools bins package;
  themes = import ./themes args;
  sync = import ./sync.nix args;
  activation = import ./activation.nix args;
  addons = import ./plugins args;
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
        inherit (addons) plugins;
        inherit package;
        quickshell = {inherit (tools.quickshell) package;};
        systemd = {
          enable = true;
          target = "graphical-session.target";
        };
      };

      xdg = {
        configFile =
          mergeSafe (
            [addons.files]
            ++ (with themes; [
              catppuccin.configFile
              foot.configFile
              hermes.configFile
              helix.configFile
            ])
          );
        inherit (themes) dataFile;
      };

      gtk = {
        enable = mkForce true;
        iconTheme = mkForce {inherit (cfg.icons) package name;};
      };

      home = {
        packages =
          (with themes.resolved.cursors; [
            dark.package
            light.package
          ])
          ++ addons.packages;
        sessionVariables = {
          QS_ICON_THEME = themes.icons.dark.theme;
        };
        activation = {
          configureDmsTheme = activation;
          configureDmsHelixTheme = themes.helix.activation;
          configureDmsPlugins = addons.activation;
          migrateDmsPlugins = addons.migration;
        };
      };

      systemd = import ./services.nix {inherit config lix sync;};
    };
  }
