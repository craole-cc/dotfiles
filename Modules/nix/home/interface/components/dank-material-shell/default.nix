{
  config,
  lib,
  lix,
  user,
  inputs,
  pkgs,
  style,
  ...
}: let
  inherit (lib.hm.dag) entryAfter;
  inherit (lix.attrsets.access) getAttr;
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.lists.aggregation) concatMap;
  inherit (lix.lists.transformation) imap0;
  inherit (lix.modules.construction) mkConfig mkContext mkForce;
  inherit (lix.options.construction) mkEnable mkOption;
  inherit (lix.sources.packages) pkgsFrom;
  inherit (lix.strings.transformation) concatStringsSep escapeShellArg stripHash;
  inherit (lix.styles.icons.types) icon;
  inherit (pkgs) writeText writeShellScript;
  gds = pkgs.gsettings-desktop-schemas;

  context = mkContext {
    inherit config;
    dom = "interface";
    sub = "panels";
    mod = "dms-shell";
  };
  inherit (context) cfg ctx;

  configHome = config.xdg.configHome or "${user.home}/.config";
  themes = {
    icons = {
      dark = config.themes.modes.dark.icon;
      light = config.themes.modes.light.icon;
    };
    cursors = {
      dark = config.themes.modes.dark.cursor;
      light = config.themes.modes.light.cursor;
    };
  };

  # TODO: Resolve in the schema so we get user > host > default
  inherit (user.theme) palettes modes;

  # Shared by every terminal: names -> hex, roles -> terminal concepts.
  # Colors keep their "#"; each app decides how to write them.
  mkTerminalPalette = palette: let
    resolve = mapAttrs (slot: colorName: palette.colors.${colorName});
    regular = resolve palette.ansi.regular;
    bright = regular // resolve palette.ansi.bright;
    ordered = slots:
      map (slot: slots.${slot})
      ["black" "red" "green" "yellow" "blue" "magenta" "cyan" "white"];
  in {
    inherit (palette) name variant foreground background;
    selectionBackground = palette.surface;
    cursor = palette.accent;
    regular = ordered regular;
    bright = ordered bright;
  };

  mkFootPalette = palette: let
    terminal = mkTerminalPalette palette;
  in ''
    # ${terminal.name}
    [colors-${terminal.variant}]
    foreground=${stripHash terminal.foreground}
    background=${stripHash terminal.background}
    selection-foreground=${stripHash terminal.foreground}
    selection-background=${stripHash terminal.selectionBackground}
    cursor=${stripHash terminal.background} ${stripHash terminal.cursor}

    ${concatStringsSep "\n" ((
        imap0
        (index: color: "regular${toString index}=${stripHash color}")
        terminal.regular
      )
      ++ (
        imap0
        (index: color: "bright${toString index}=${stripHash color}")
        terminal.bright
      ))}
  '';

  mkKittyPalette = palette: let
    terminal = mkTerminalPalette palette;
  in ''
    # ${terminal.name}
    foreground ${terminal.foreground}
    background ${terminal.background}
    selection_foreground ${terminal.foreground}
    selection_background ${terminal.selectionBackground}
    cursor ${terminal.cursor}

    ${concatStringsSep "\n" (
      imap0
      (index: color: "color${toString index} ${color}")
      (terminal.regular ++ terminal.bright)
    )}
  '';

  mkGhosttyPalette = palette: let
    terminal = mkTerminalPalette palette;
  in ''
    # ${terminal.name}
    foreground = ${terminal.foreground}
    background = ${terminal.background}
    selection-foreground = ${terminal.foreground}
    selection-background = ${terminal.selectionBackground}
    cursor-color = ${terminal.cursor}
    ${concatStringsSep "\n" (
      imap0
      (index: color: "palette = ${toString index}=${color}")
      (terminal.regular ++ terminal.bright)
    )}
  '';

  mkThemeEntry = home: spec: {
    "${home}/${spec.file}".source = spec.path;
  };

  mkThemeModals = {
    modes ? ["dark" "light"],
    types ? ["icons" "cursors"],
  }: let
    mk = mode: type: let
      selected = getAttr mode (getAttr type {inherit icons cursors;});
    in {"icons/${selected.theme}" = {inherit (selected) source;};};
  in
    concatMap (type: map (mode: mk mode type) modes) types;

  tools = pkgsFrom {
    inherit inputs pkgs;
    sources = {
      coreutils = null;
      dms-shell = null;
      glib = null;
      jaq = null;
      procps = null;
      ripgrep = null;
      sd = null;
    };
    required = true;
  };

  bins = let
    inherit (tools) binaries;
    coreutils = "${tools.coreutils.paths.bin}";
    glib = "${tools.glib.paths.bin}";
  in rec {
    inherit (binaries) jaq sd;
    cat = "${coreutils}/cat";
    cmp = "${coreutils}/cmp";
    dirname = "${coreutils}/dirname";
    dms = binaries.dms-shell;
    dmsCall = "${dms} ipc call";
    dmsSet = "${dmsCall} settings set";
    gCall = "${glib}/gdbus call";
    gSet = "${gsettings} set";
    gSetDI = "${gSet} org.gnome.desktop.interface";
    gsettings = "${glib}/gsettings";
    install = "${coreutils}/install";
    mkdir = "${coreutils}/mkdir";
    mktemp = "${coreutils}/mktemp";
    pkill = binaries.procps;
    rg = binaries.ripgrep;
  };

  cursors = mapAttrs (_: resolved: rec {
    theme = resolved.name;
    name = escapeShellArg theme;
    source = "${resolved.package}/share/icons/${theme}";
    inherit (resolved) size;
  }) themes.cursors;

  icons = {
    dark = rec {
      theme = themes.icons.dark.name;
      name = escapeShellArg theme;
      source = concat {
        root = themes.icons.dark.package;
        stem = ["share" "icons" theme];
      };
    };
    light = rec {
      theme = themes.icons.light.name;
      name = escapeShellArg theme;
      source = "${themes.icons.light.package}/share/icons/${theme}";
    };
    resolved = themes.icons.dark;
  };

  apps = {
    catppuccin = let
      name = "catppuccin";
      theme = {
      };
      path = concat {
        root = configHome;
        stem = ["DankMaterialShell" "themes" "${name}.json"];
      };
      source = ./dms-catppuccin.json;
      pathStr = escapeShellArg path;
    in {inherit name path pathStr source;};

    foot = let
      name = "foot";
      path = concat {
        root = configHome;
        stem = [name "dank-colors.ini"];
      };
      theme = {
        mutagen = let
          tag = "${name}-matugen-theme";
          file = "${tag}.toml";
        in {
          name = tag;
          target = concat {
            root = configHome;
            stem = ["matugen" "dms" "configs" file];
          };
          source = writeText file ''
            [templates.${tag}]
            input_path = '${./${tag}.ini}'
            output_path = '${path}'
          '';
        };

        fallback = let
          tag = "${name}-fallback-theme";
          file = "${tag}.ini";
        in {
          name = tag;
          target = path;
          source = writeText file (concatStringsSep "\n" (
            map mkFootPalette (with modes; [dark light])
          ));
        };
      };
    in {inherit theme;};

    hermes = let
      name = "hermes";
      home = ".hermes";
    in {
      source = let
        tag = "${name}-matugen";
        template = ./${tag}.yaml;
      in
        writeText "dotdots-${tag}.toml" ''
          [templates.dotdots_${name}]
          input_path = '${template}'
          output_path = '${concat {
            root = config.home.homeDirectory;
            stem = [home "skins" "dms-wallpaper.yaml"];
          }}'
          # output_path = '${config.home.homeDirectory}/.hermes/skins/dms-wallpaper.yaml'
        '';
    };

    ghostty = {
      opacity = {
        fallback = writeText "dotdots-ghostty-opacity" ''
          background-opacity = ${toString style.opacity.terminal.dark}
        '';
      };
    };

    kitty = {
      opacity = {
        fallback = writeText "dotdots-kitty-opacity.conf" ''
          background_opacity ${toString style.opacity.terminal.dark}
        '';
      };
    };

    dms = {
      theme = apps.catppuccin; #TODO: This needs to be schema driven
      sync = writeShellScript "sync-dms-desktop-appearance" ''
        mode="$(${bins.dmsCall} theme getMode 2>/dev/null || true)"
        settings=${escapeShellArg "${config.xdg.configHome}/DankMaterialShell/settings.json"}

        case "$mode" in
          dark)
            cursor=${cursors.dark.name}
            cursor_size=${toString cursors.dark.size}
            icons=${icons.dark.name}
            color_scheme=prefer-dark
            terminal_opacity=${toString style.opacity.terminal.dark}
            btop_theme=adwaita-dark
            foot_signal=USR1
            ;;
          light)
            cursor=${cursors.light.name}
            cursor_size=${toString cursors.light.size}
            icons=${icons.light.name}
            color_scheme=prefer-light
            terminal_opacity=${toString style.opacity.terminal.light}
            btop_theme=adwaita
            foot_signal=USR2
            ;;
          *) exit 0 ;;
        esac

        # DMS regenerates Hyprland's cursor.lua from this mutable setting.
        # Only write when it differs, so the settings path cannot retrigger forever.
        if [ -f "$settings" ] && [ ! -L "$settings" ] &&
          ${bins.jaq} -e \
            --arg cursor "$cursor" \
            --argjson size "$cursor_size" \
            '.cursorSettings.theme != $cursor or .cursorSettings.size != $size' \
            "$settings" >/dev/null; then

          if tmp="$(${bins.mktemp} "$settings.tmp.XXXXXX")"; then
            trap '${bins.rm} -f "$tmp"' EXIT
            if
              ${bins.jaq} \
                --arg cursor "$cursor" \
                --argjson size "$cursor_size" \
                '.cursorSettings = ((.cursorSettings // {}) + {theme: $cursor, size: $size})' \
                "$settings" > "$tmp"
            then
              ${bins.chmod} --reference="$settings" "$tmp"
              ${bins.mv} -f "$tmp" "$settings"
            fi
            trap - EXIT
            ${bins.rm} -f "$tmp"
          fi
        fi

        xresources="$HOME/.Xresources"
        xresources_writable=false
        if [ -L "$xresources" ]; then
          :
        elif [ -e "$xresources" ] && [ -w "$xresources" ]; then
            xresources_writable=true
        else
          :
        fi

        xresources_needs_update=false
        if [ -f "$xresources" ]; then
          if ${bins.rg} -Fxq "Xcursor.theme: $cursor" "$xresources" &&
            ${bins.rg} -Fxq "Xcursor.size: $cursor_size" "$xresources"; then
            :
          else
            xresources_needs_update=true
          fi
        else
          xresources_needs_update=true
        fi

        if [ "$xresources_writable" = true ] && [ "$xresources_needs_update" = true ]; then
          if tmp="$(${bins.mktemp} "$xresources.tmp.XXXXXX")"; then
            trap '${bins.rm} -f "$tmp"' EXIT
            xresources_filtered=true
            if [ -f "$xresources" ]; then
              if ${bins.jaq} -Rr 'select(test("^[[:space:]]*Xcursor\\.(theme|size):") | not)' \
                  "$xresources" > "$tmp"; then
                :
              else
                xresources_filtered=false
              fi
            else
              : > "$tmp"
            fi
            if [ "$xresources_filtered" = true ]; then
              printf 'Xcursor.theme: %s\nXcursor.size: %s\n' "$cursor" "$cursor_size" >> "$tmp"
              if [ -f "$xresources" ]; then
                ${bins.chmod} --reference="$xresources" "$tmp"
              fi
              ${bins.mv} -f "$tmp" "$xresources"
              command -v xrdb >/dev/null 2>&1 && xrdb -merge "$xresources" >/dev/null 2>&1 || true
            fi
            trap - EXIT
            ${bins.rm} -f "$tmp"
          fi
        fi

        export GSETTINGS_SCHEMA_DIR="${gds}/share/gsettings-schemas/${gds.name}/glib-2.0/schemas"
        ${bins.gSetDI} color-scheme "$color_scheme" || true
        ${bins.gSetDI} cursor-theme "$cursor" || true
        ${bins.gSetDI} cursor-size "$cursor_size" || true
        ${bins.gSetDI} icon-theme "$icons" || true
        command -v hyprctl >/dev/null 2>&1 && hyprctl setcursor "$cursor" "$cursor_size" >/dev/null 2>&1 || true

        write_opacity_file() {
          local target="$1" setting="$2" tmp
          if [ -L "$target" ]; then
            echo "Refusing to replace managed terminal opacity symlink: $target" >&2
            return 1
          fi
          if [ -f "$target" ] && [ "$(${bins.cat} "$target")" = "$setting" ]; then
            return 1
          fi
          ${bins.mkdir} -p "$(${bins.dirname} "$target")"
          tmp="$(${bins.mktemp} "$target.tmp.XXXXXX")" || return 1
          printf '%s\n' "$setting" > "$tmp"
          ${bins.chmod} 0644 "$tmp"
          ${bins.mv} -f "$tmp" "$target"
        }

        ghostty_opacity=${escapeShellArg "${config.xdg.configHome}/ghostty/dotdots-opacity"}
        kitty_opacity=${escapeShellArg "${config.xdg.configHome}/kitty/dotdots-opacity.conf"}
        if write_opacity_file "$ghostty_opacity" "background-opacity = $terminal_opacity"; then
          ${bins.gCall} \
            --session \
            --dest com.mitchellh.ghostty \
            --object-path /com/mitchellh/ghostty \
            --method org.gtk.Actions.Activate reload-config '[]' '{}' >/dev/null 2>&1 || true
        fi
        if write_opacity_file "$kitty_opacity" "background_opacity $terminal_opacity"; then
          ${bins.pkill} -USR1 -x kitty || true
        fi

        btop_config=${escapeShellArg "${config.xdg.configHome}/btop/btop.conf"}
        if [ -L "$btop_config" ]; then
          echo "Refusing to replace managed btop config symlink: $btop_config" >&2
        else
          ${bins.mkdir} -p "$(${bins.dirname} "$btop_config")"
          if tmp="$(${bins.mktemp} "$btop_config.tmp.XXXXXX")"; then
            if [ -f "$btop_config" ]; then
              if ! ${bins.cat} "$btop_config" |
                ${bins.sd} '^\\s*color_theme\\s*=.*' "color_theme = \"$btop_theme\"" |
                ${bins.sd} '^\\s*theme_background\\s*=.*' 'theme_background = false' > "$tmp"; then
                ${bins.rm} -f "$tmp"
                tmp=
              else
                ${bins.rg} -q '^[[:space:]]*color_theme[[:space:]]*=' "$btop_config" ||
                  printf 'color_theme = "%s"\n' "$btop_theme" >> "$tmp"
                ${bins.rg} -q '^[[:space:]]*theme_background[[:space:]]*=' "$btop_config" ||
                  printf 'theme_background = false\n' >> "$tmp"
                ${bins.chmod} --reference="$btop_config" "$tmp"
              fi
            else
              printf 'color_theme = "%s"\ntheme_background = false\n' "$btop_theme" > "$tmp"
              ${bins.chmod} 0644 "$tmp"
            fi
            if [ -n "$tmp" ]; then
              if [ ! -f "$btop_config" ] || ! ${bins.cmp} -s "$tmp" "$btop_config"; then
                if ${bins.mv} -f "$tmp" "$btop_config"; then
                  ${bins.pkill} -USR2 -x btop || true
                else
                  ${bins.rm} -f "$tmp"
                fi
              else
                ${bins.rm} -f "$tmp"
              fi
            fi
          fi
        fi
        ${bins.pkill} -"$foot_signal" -x foot || true
      '';
    };
  };
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable ({inherit context;} // ctx.wantsDmsShell);
      icons = mkOption {
        description = "Resolved DMS desktop icon contract";
        default = icons.resolved;
        type = icon.home;
        readOnly = true;
      };
    };

    outputs = {
      programs = {
        # dank-material-shell = {
        #   inherit (cfg) enable;

        #   # The flake module is still used for Home Manager integration, but its
        #   # pinned package closure is expensive to rebuild locally. Victus tracks
        #   # nixos-unstable, where both packages are available from nixpkgs and can
        #   # normally be substituted from cache.nixos.org.
        #   inherit (tools.dms-shell) package;
        #   quickshell = {inherit (tools.quickshell) package;};

        #   systemd = {
        #     enable = true;
        #     target = "graphical-session.target";
        #   };
        # };
      };

      xdg = {
        configFile = mergeSafe (with apps; [
          # (mkThemeEntry "DankMaterialShell/themes" dms.theme)
          # (mkThemeEntry "matugen/dms/configs" foot.theme.mutagen.source)
          (with apps.foot.theme.mutagen; {"${target}" = {inherit source;};})
          # (mkThemeEntry "matugen/dms/configs" hermes.theme)
        ]);
        dataFile = mergeSafe (mkThemeModals {});
      };

      gtk = {
        enable = mkForce true;
        iconTheme = mkForce {inherit (cfg.icons) package name;};
      };

      home = {
        packages = [themes.cursors.dark.package themes.cursors.light.package];
        sessionVariables = {
          # DMS owns its mutable settings file. Preserve the user's bar/widget/etc.
          QS_ICON_THEME = icons.dark.theme;
        };

        activation.configureDmsTheme = let
          inherit (bins) dirname dmsSet install jaq mkdir mktemp rm;
          inherit (apps) foot ghostty kitty;
        in
          entryAfter ["writeBoundary"] ''
            settings="$HOME/.config/DankMaterialShell/settings.json"
            foot_theme="$HOME/.config/foot/dank-colors.ini"
            ghostty_opacity="$HOME/.config/ghostty/dotdots-opacity"
            kitty_opacity="$HOME/.config/kitty/dotdots-opacity.conf"
            theme="${apps.dms.theme.pathStr}"
            dark_icons="${icons.dark.name}"
            light_icons="${icons.light.name}"
            tmp="$(${mktemp})"
            trap '${rm} -f "$tmp"' EXIT

            $DRY_RUN_CMD ${mkdir} -p "$(${dirname} "$settings")"
            $DRY_RUN_CMD ${mkdir} -p "$(${dirname} "$foot_theme")"
            $DRY_RUN_CMD ${mkdir} -p "$(${dirname} "$ghostty_opacity")"
            $DRY_RUN_CMD ${mkdir} -p "$(${dirname} "$kitty_opacity")"
            $DRY_RUN_CMD ${mkdir} -p "$HOME/.hermes/skins"
            if [ -e "$foot_theme" ]; then :; else
              $DRY_RUN_CMD ${install} -m 0644 ${foot.fallback} "$foot_theme"
            fi
            if [ -e "$ghostty_opacity" ] || [ -L "$ghostty_opacity" ]; then :; else
              $DRY_RUN_CMD ${install} -m 0644 ${ghostty.opacity.fallback} "$ghostty_opacity"
            fi
            if [ -e "$ghostty_opacity" ] || [ -L "$ghostty_opacity" ]; then :; else
              $DRY_RUN_CMD ${install} -m 0644 ${kitty.opacity.fallback} "$kitty_opacity"
            fi

            if [ -L "$settings" ]; then
              echo "Refusing to replace managed DMS settings symlink: $settings" >&2
              exit 1
            fi

            if [ -f "$settings" ]; then
              ${jaq} \
                --arg theme "$theme" \
                --arg darkIcons "$dark_icons" \
                --arg lightIcons "$light_icons" '
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
              ${jaq} -n \
                --arg theme "$theme" \
                --arg darkIcons "$dark_icons" \
                --arg lightIcons "$light_icons" '{
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

            $DRY_RUN_CMD ${install} -m 0600 "$tmp" "$settings"

            # Set the theme category before its name. Selecting the dynamic theme
            # makes subsequent DMS wallpaper changes drive Matugen regeneration.
            $DRY_RUN_CMD ${dmsSet} customThemeFile "$theme" >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} matugenScheme scheme-smart >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} matugenContrast -0.35 >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} runDmsMatugenTemplates true >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} matugenTemplateGtk true >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} matugenTemplateGhostty true >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} matugenTemplateFoot false >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} matugenTemplateVscode true >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} matugenTemplateZed true >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} matugenTemplateZenBrowser true >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} iconThemeDark "$dark_icons" >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} iconThemeLight "$light_icons" >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} iconThemePerMode true >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} currentThemeCategory dynamic >/dev/null 2>&1 || true
            $DRY_RUN_CMD ${dmsSet} currentThemeName dynamic >/dev/null 2>&1 || true
          '';
      };

      systemd = {
        user = {
          services.dotdots-foot-dms-theme-reload = {
            Unit = {
              Description = "Apply DMS appearance to desktop and terminals";
              StartLimitIntervalSec = 0;
            };
            Service = {
              Type = "oneshot";
              ExecStart = apps.dms.sync;
            };
            Install.WantedBy = ["graphical-session.target"];
          };

          paths.dotdots-foot-dms-theme-reload = {
            Unit.Description = "Watch DMS appearance settings and terminal palettes";
            Path.PathChanged = [
              "%h/.config/DankMaterialShell/settings.json"
              "%h/.config/foot/dank-colors.ini"
              "%h/.config/btop/btop.conf"
            ];
            Install.WantedBy = ["graphical-session.target"];
          };
        };
      };
    };
  }
