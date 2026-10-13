{
  config,
  inputs,
  lib,
  lix,
  pkgs,
  ...
}: let
  inherit (lib.hm.dag) entryAfter;
  inherit (lix.modules.construction) mkConfig mkContext mkForce;
  inherit (lix.options.construction) mkEnable mkOption;
  inherit (lix.strings.transformation) escapeShellArg;
  inherit (pkgs) coreutils dms-shell glib gnugrep jq procps quickshell;

  context = mkContext {
    inherit config;
    dom = "interface";
    sub = "panels";
    mod = "dms-shell";
  };
  inherit (context) cfg ctx;

  buufIcons = pkgs.stdenvNoCC.mkDerivation {
    pname = "buuf-icons";
    version = "unstable-2026-10-12";
    src = inputs.buuf-icons;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/icons/Buuf"
      cp -R "$src"/. "$out/share/icons/Buuf/"
      runHook postInstall
    '';
  };
  darkIconTheme = "Buuf";
  lightIconTheme = "candy-icons";
  darkCursorTheme = "material_dark_cursors";
  lightCursorTheme = "catppuccin-latte-mauve-cursors";
  cursorSize = 24;
  resolvedIcons = {name = darkIconTheme; package = buufIcons;};

  darkIcons = escapeShellArg darkIconTheme;
  lightIcons = escapeShellArg lightIconTheme;
  themeName = "dotdots-catppuccin";
  themeFile = ./dms-catppuccin.json;
  themePath = "${config.xdg.configHome}/DankMaterialShell/themes/${themeName}.json";
  footMatugenTemplate = ./foot-matugen.ini;
  footMatugenConfig = pkgs.writeText "dotdots-foot-matugen.toml" ''
    [templates.dotdots_foot]
    input_path = '${footMatugenTemplate}'
    output_path = '${config.xdg.configHome}/foot/dank-colors.ini'
  '';
  hermesMatugenTemplate = ./hermes-matugen.yaml;
  hermesMatugenConfig = pkgs.writeText "dotdots-hermes-matugen.toml" ''
    [templates.dotdots_hermes]
    input_path = '${hermesMatugenTemplate}'
    output_path = '${config.home.homeDirectory}/.hermes/skins/dms-wallpaper.yaml'
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
  syncDmsAppearance = pkgs.writeShellScript "sync-dms-desktop-appearance" ''
    mode="$(${dms-shell}/bin/dms ipc call theme getMode 2>/dev/null || true)"
    settings=${escapeShellArg "${config.xdg.configHome}/DankMaterialShell/settings.json"}

    case "$mode" in
      dark)
        cursor=${escapeShellArg darkCursorTheme}
        icons=${escapeShellArg darkIconTheme}
        color_scheme=prefer-dark
        foot_signal=USR1
        ;;
      light)
        cursor=${escapeShellArg lightCursorTheme}
        icons=${escapeShellArg lightIconTheme}
        color_scheme=prefer-light
        foot_signal=USR2
        ;;
      *) exit 0 ;;
    esac

    # DMS regenerates Hyprland's cursor.lua from this mutable setting.
    # Only write when it differs, so the settings path cannot retrigger forever.
    if [ -f "$settings" ] && [ ! -L "$settings" ] &&
       ${jq}/bin/jq -e --arg cursor "$cursor" --argjson size ${toString cursorSize} \
         '.cursorSettings.theme != $cursor or .cursorSettings.size != $size' \
         "$settings" >/dev/null; then
      if tmp="$(${coreutils}/bin/mktemp "$settings.tmp.XXXXXX")"; then
        trap '${coreutils}/bin/rm -f "$tmp"' EXIT
        if ${jq}/bin/jq --arg cursor "$cursor" --argjson size ${toString cursorSize} \
          '.cursorSettings = ((.cursorSettings // {}) + {theme: $cursor, size: $size})' \
          "$settings" > "$tmp"; then
          ${coreutils}/bin/chmod --reference="$settings" "$tmp"
          ${coreutils}/bin/mv -f "$tmp" "$settings"
        fi
        trap - EXIT
        ${coreutils}/bin/rm -f "$tmp"
      fi
    fi

    xresources="$HOME/.Xresources"
    if [ ! -L "$xresources" ] && { [ ! -e "$xresources" ] || [ -w "$xresources" ]; } &&
       { [ ! -f "$xresources" ] ||
         ! ${gnugrep}/bin/grep -Fxq "Xcursor.theme: $cursor" "$xresources" ||
         ! ${gnugrep}/bin/grep -Fxq 'Xcursor.size: ${toString cursorSize}' "$xresources"; }; then
      if tmp="$(${coreutils}/bin/mktemp "$xresources.tmp.XXXXXX")"; then
        trap '${coreutils}/bin/rm -f "$tmp"' EXIT
        if [ ! -f "$xresources" ] ||
           ${jq}/bin/jq -Rr 'select(test("^[[:space:]]*Xcursor\\.(theme|size):") | not)' \
             "$xresources" > "$tmp"; then
          printf 'Xcursor.theme: %s\nXcursor.size: %s\n' "$cursor" ${toString cursorSize} >> "$tmp"
          if [ -f "$xresources" ]; then
            ${coreutils}/bin/chmod --reference="$xresources" "$tmp"
          fi
          ${coreutils}/bin/mv -f "$tmp" "$xresources"
          command -v xrdb >/dev/null 2>&1 && xrdb -merge "$xresources" >/dev/null 2>&1 || true
        fi
        trap - EXIT
        ${coreutils}/bin/rm -f "$tmp"
      fi
    fi

    ${glib}/bin/gsettings set org.gnome.desktop.interface color-scheme "$color_scheme" || true
    ${glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme "$cursor" || true
    ${glib}/bin/gsettings set org.gnome.desktop.interface cursor-size ${toString cursorSize} || true
    ${glib}/bin/gsettings set org.gnome.desktop.interface icon-theme "$icons" || true
    command -v hyprctl >/dev/null 2>&1 && hyprctl setcursor "$cursor" ${toString cursorSize} >/dev/null 2>&1 || true
    ${procps}/bin/pkill -"$foot_signal" -x foot || true
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
        configFile."matugen/dms/configs/dotdots-hermes.toml".source = hermesMatugenConfig;
        dataFile."icons/${darkIconTheme}".source = "${buufIcons}/share/icons/${darkIconTheme}";
        dataFile."icons/${lightIconTheme}".source = "${pkgs.candy-icons}/share/icons/${lightIconTheme}";
        dataFile."icons/${darkCursorTheme}".source = "${pkgs.material-cursors}/share/icons/${darkCursorTheme}";
        dataFile."icons/${lightCursorTheme}".source = "${pkgs.catppuccin-cursors.latteMauve}/share/icons/${lightCursorTheme}";
      };

      home.packages = [
        pkgs.material-cursors
        pkgs.catppuccin-cursors.latteMauve
      ];

      gtk = {
        enable = mkForce true;
        iconTheme = mkForce {inherit (cfg.icons) package name;};
      };

      home.sessionVariables.QS_ICON_THEME = darkIconTheme;

      systemd.user = {
        services.dotdots-foot-dms-theme-reload = {
          Unit.Description = "Apply DMS appearance to GTK, cursors, and Foot";
          Service = {
            Type = "oneshot";
            ExecStart = syncDmsAppearance;
          };
          Install.WantedBy = ["graphical-session.target"];
        };

        paths.dotdots-foot-dms-theme-reload = {
          Unit.Description = "Watch DMS appearance settings and the generated Foot palette";
          Path = {
            PathChanged = [
              "%h/.config/DankMaterialShell/settings.json"
              "%h/.config/foot/dank-colors.ini"
            ];
          };
          Install.WantedBy = ["graphical-session.target"];
        };
      };

      # DMS owns its mutable settings file. Preserve the user's bar/widget/etc.
      # settings and only assert the declarative dotDots theme selection.
      home.activation.configureDmsTheme = entryAfter ["writeBoundary"] ''
        settings="$HOME/.config/DankMaterialShell/settings.json"
        foot_theme="$HOME/.config/foot/dank-colors.ini"
        theme=${escapeShellArg themePath}
        dark_icons=${darkIcons}
        light_icons=${lightIcons}
        tmp="$(${coreutils}/bin/mktemp)"
        trap '${coreutils}/bin/rm -f "$tmp"' EXIT

        $DRY_RUN_CMD ${coreutils}/bin/mkdir -p "$(${coreutils}/bin/dirname "$settings")"
        $DRY_RUN_CMD ${coreutils}/bin/mkdir -p "$(${coreutils}/bin/dirname "$foot_theme")"
        $DRY_RUN_CMD ${coreutils}/bin/mkdir -p "$HOME/.hermes/skins"
        if [ ! -e "$foot_theme" ]; then
          $DRY_RUN_CMD ${coreutils}/bin/install -m 0644 ${footFallback} "$foot_theme"
        fi

        if [ -L "$settings" ]; then
          echo "Refusing to replace managed DMS settings symlink: $settings" >&2
          exit 1
        fi

        if [ -f "$settings" ]; then
          ${jq}/bin/jq --arg theme "$theme" --arg darkIcons "$dark_icons" --arg lightIcons "$light_icons" '
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
              iconThemeDark: $darkIcons,
              iconThemeLight: $lightIcons,
              iconThemePerMode: true
            }
          ' "$settings" > "$tmp"
        else
          ${jq}/bin/jq -n --arg theme "$theme" --arg darkIcons "$dark_icons" --arg lightIcons "$light_icons" '{
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
            iconThemeDark: $darkIcons,
            iconThemeLight: $lightIcons,
            iconThemePerMode: true
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
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set iconThemeDark "$dark_icons" >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set iconThemeLight "$light_icons" >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set iconThemePerMode true >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set currentThemeCategory dynamic >/dev/null 2>&1 || true
        $DRY_RUN_CMD ${dms-shell}/bin/dms ipc call settings set currentThemeName dynamic >/dev/null 2>&1 || true
      '';
    };
  }
