{
  config,
  lib,
  lix,
  pkgs,
  ...
}: let
  inherit (lib.hm.dag) entryAfter;
  inherit (lix.modules.construction) mkConfig mkContext mkForce;
  inherit (lix.options.construction) mkEnable mkOption;
  inherit (lix.strings.transformation) escapeShellArg;
  inherit (pkgs) coreutils dms-shell jq procps quickshell;

  context = mkContext {
    inherit config;
    dom = "interface";
    sub = "panels";
    mod = "dms-shell";
  };
  inherit (context) cfg ctx;

  resolvedIcons = {
    name = "candy-icons";
    package = pkgs.candy-icons;
  };

  iconTheme = cfg.icons.name;
  themeName = "dotdots-catppuccin";
  themeFile = ./dms-catppuccin.json;
  themePath = "${config.xdg.configHome}/DankMaterialShell/themes/${themeName}.json";
  footMatugenTemplate = ./foot-matugen.ini;
  footMatugenConfig = pkgs.writeText "dotdots-foot-matugen.toml" ''
    [templates.dotdots_foot]
    input_path = '${footMatugenTemplate}'
    output_path = '${config.xdg.configHome}/foot/dank-colors.ini'
  '';
  footFallback = pkgs.writeText "dms-foot-fallback.ini" ''
    [colors-dark]
    foreground=c6d0f5
    background=303446
    selection-foreground=c6d0f5
    selection-background=51576d
    cursor=303446 ca9ee6

    regular0=51576d
    regular1=e78284
    regular2=a6d189
    regular3=e5c890
    regular4=8caaee
    regular5=ca9ee6
    regular6=81c8be
    regular7=b5bfe2
    bright0=626880
    bright1=e78284
    bright2=a6d189
    bright3=e5c890
    bright4=8caaee
    bright5=ca9ee6
    bright6=81c8be
    bright7=c6d0f5

    [colors-light]
    foreground=4c4f69
    background=eff1f5
    selection-foreground=4c4f69
    selection-background=acb0be
    cursor=eff1f5 dc8a78

    regular0=acb0be
    regular1=d20f39
    regular2=40a02b
    regular3=df8e1d
    regular4=1e66f5
    regular5=ea76cb
    regular6=179299
    regular7=5c5f77
    bright0=9ca0b0
    bright1=d20f39
    bright2=40a02b
    bright3=df8e1d
    bright4=1e66f5
    bright5=ea76cb
    bright6=179299
    bright7=4c4f69
  '';
  reloadFoot = pkgs.writeShellScript "reload-foot-dms-theme" ''
    mode="$(${dms-shell}/bin/dms ipc call theme getMode 2>/dev/null || true)"

    case "$mode" in
      dark)
        ${procps}/bin/pkill -USR1 -x foot || true
        ;;
      light)
        ${procps}/bin/pkill -USR2 -x foot || true
        ;;
    esac
  '';
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable ({inherit context;} // ctx.wantsDmsShell);
      icons = mkOption {
        description = "Resolved DMS desktop icon contract";
        default = resolvedIcons;
        type = lix.styles.icons.types.icon.home;
        readOnly = true;
      };
    };
    outputs = {
      programs.dank-material-shell = {
        inherit (cfg) enable;

        # The flake module is still used for Home Manager integration, but its
        # pinned package closure is expensive to rebuild locally. Victus tracks
        # nixos-unstable, where both packages are available from nixpkgs and can
        # normally be substituted from cache.nixos.org.
        package = dms-shell;
        quickshell.package = quickshell;

        systemd = {
          enable = true;
          target = "graphical-session.target";
        };
      };

      xdg = {
        configFile."DankMaterialShell/themes/${themeName}.json".source = themeFile;
        configFile."matugen/dms/configs/dotdots-foot.toml".source = footMatugenConfig;
        dataFile."icons/${cfg.icons.name}".source = "${cfg.icons.package}/share/icons/${cfg.icons.name}";
      };

      gtk = {
        enable = mkForce true;
        iconTheme = mkForce {inherit (cfg.icons) package name;};
      };

      home.sessionVariables.QS_ICON_THEME = cfg.icons.name;

      systemd.user = {
        services.dotdots-foot-dms-theme-reload = {
          Unit.Description = "Switch Foot to DMS's active colour mode";
          Service = {
            Type = "oneshot";
            ExecStart = reloadFoot;
          };
        };

        paths.dotdots-foot-dms-theme-reload = {
          Unit.Description = "Watch the DMS-generated Foot palette";
          Path.PathChanged = "%h/.config/foot/dank-colors.ini";
          Install.WantedBy = ["graphical-session.target"];
        };
      };

      # DMS owns its mutable settings file. Preserve the user's bar/widget/etc.
      # settings and only assert the declarative dotDots theme selection.
      home.activation.configureDmsTheme = entryAfter ["writeBoundary"] ''
        settings="$HOME/.config/DankMaterialShell/settings.json"
        foot_theme="$HOME/.config/foot/dank-colors.ini"
        theme=${escapeShellArg themePath}
        icons=${escapeShellArg iconTheme}
        tmp="$(${coreutils}/bin/mktemp)"
        trap '${coreutils}/bin/rm -f "$tmp"' EXIT

        $DRY_RUN_CMD ${coreutils}/bin/mkdir -p "$(${coreutils}/bin/dirname "$settings")"
        $DRY_RUN_CMD ${coreutils}/bin/mkdir -p "$(${coreutils}/bin/dirname "$foot_theme")"
        if [ ! -e "$foot_theme" ]; then
          $DRY_RUN_CMD ${coreutils}/bin/install -m 0644 ${footFallback} "$foot_theme"
        fi

        if [ -L "$settings" ]; then
          echo "Refusing to replace managed DMS settings symlink: $settings" >&2
          exit 1
        fi

        if [ -f "$settings" ]; then
          ${jq}/bin/jq --arg theme "$theme" --arg icons "$icons" '
            . + {
              currentThemeName: "dynamic",
              currentThemeCategory: "dynamic",
              customThemeFile: $theme,
              matugenScheme: "scheme-smart",
              matugenContrast: -0.35,
              screenPreferences: {wallpaper: ["all"]},
              runDmsMatugenTemplates: true,
              matugenTemplateGtk: true,
              matugenTemplateGhostty: true,
              matugenTemplateFoot: false,
              matugenTemplateVscode: true,
              matugenTemplateZed: true,
              matugenTemplateZenBrowser: true,
              iconThemeDark: $icons,
              iconThemeLight: $icons,
              iconThemePerMode: false
            }
          ' "$settings" > "$tmp"
        else
          ${jq}/bin/jq -n --arg theme "$theme" --arg icons "$icons" '{
            currentThemeName: "dynamic",
            currentThemeCategory: "dynamic",
            customThemeFile: $theme,
            matugenScheme: "scheme-smart",
            matugenContrast: -0.35,
            screenPreferences: {wallpaper: ["all"]},
            runDmsMatugenTemplates: true,
            matugenTemplateGtk: true,
            matugenTemplateGhostty: true,
            matugenTemplateFoot: false,
            matugenTemplateVscode: true,
            matugenTemplateZed: true,
            matugenTemplateZenBrowser: true,
            iconThemeDark: $icons,
            iconThemeLight: $icons,
            iconThemePerMode: false
          }' > "$tmp"
        fi

        $DRY_RUN_CMD ${coreutils}/bin/install -m 0600 "$tmp" "$settings"

        # Set the theme category before its name. Selecting the dynamic theme
        # makes subsequent DMS wallpaper changes drive Matugen regeneration.
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set customThemeFile "$theme" >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set matugenScheme scheme-smart >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set matugenContrast -0.35 >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set runDmsMatugenTemplates true >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set matugenTemplateGtk true >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set matugenTemplateGhostty true >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set matugenTemplateFoot false >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set matugenTemplateVscode true >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set matugenTemplateZed true >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set matugenTemplateZenBrowser true >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set iconThemeDark "$icons" >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set iconThemeLight "$icons" >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set iconThemePerMode false >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set currentThemeCategory dynamic >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set currentThemeName dynamic >/dev/null 2>&1 || true
      '';
    };
  }
