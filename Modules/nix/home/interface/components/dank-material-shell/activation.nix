{
  bins,
  config,
  inputs,
  lix,
  style,
  templates,
  themes,
  user,
}: let
  inherit (inputs.home-manager.lib.hm.dag) entryAfter;
  inherit (lix.strings.construction) toJSON;
  inherit (lix.strings.transformation) escapeShellArg;
  inherit (themes) icons;
  inherit (bins) dirname install jaq mkdir mktemp rm;
  inherit (templates) foot ghostty kitty;
in
  entryAfter ["writeBoundary"] ''
    settings=${escapeShellArg "${config.xdg.configHome}/DankMaterialShell/settings.json"}
    session=${escapeShellArg "${config.xdg.stateHome}/DankMaterialShell/session.json"}
    foot_theme=${escapeShellArg "${config.xdg.configHome}/foot/dank-colors.ini"}
    ghostty_opacity=${escapeShellArg "${config.xdg.configHome}/ghostty/dotdots-opacity"}
    kitty_opacity=${escapeShellArg "${config.xdg.configHome}/kitty/dotdots-opacity.conf"}

    if [ -n "$DRY_RUN_CMD" ]; then
      echo "Would seed missing DMS settings and terminal appearance files"
    else
      ${mkdir} -p "$(${dirname} "$settings")" "$(${dirname} "$session")" \
        "$(${dirname} "$foot_theme")" "$(${dirname} "$ghostty_opacity")" \
        "$(${dirname} "$kitty_opacity")" "$HOME/.hermes/skins"
      if [ ! -e "$foot_theme" ] && [ ! -L "$foot_theme" ]; then
        ${install} -m 0644 ${foot.theme.fallback.source} "$foot_theme"
      fi
      if [ ! -e "$ghostty_opacity" ] && [ ! -L "$ghostty_opacity" ]; then
        ${install} -m 0644 ${ghostty.opacity.fallback} "$ghostty_opacity"
      fi
      if [ ! -e "$kitty_opacity" ] && [ ! -L "$kitty_opacity" ]; then
        ${install} -m 0644 ${kitty.opacity.fallback} "$kitty_opacity"
      fi

      # DMS owns its mutable files while running. Seed declarative defaults on
      # first use; activation must preserve the user's saved choices.
      tmp="$(${mktemp})"
      trap '${rm} -f "$tmp"' EXIT
      if [ ! -e "$settings" ] && [ ! -L "$settings" ]; then
        ${jaq} -n \
          --arg theme ${escapeShellArg templates.catppuccin.pathStr} \
          --arg darkIcons ${escapeShellArg icons.dark.name} \
          --arg lightIcons ${escapeShellArg icons.light.name} '{
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
        ${install} -m 0600 "$tmp" "$settings"
      fi
      if [ ! -e "$session" ] && [ ! -L "$session" ]; then
        printf '%s\n' ${escapeShellArg (toJSON {
      isLightMode = style.mode == "light";
      themeModeAutoEnabled = user.theme.modes.autoSwitch or false;
    })} > "$tmp"
        ${install} -m 0600 "$tmp" "$session"
      fi
      ${rm} -f "$tmp"
      trap - EXIT
    fi
  ''
