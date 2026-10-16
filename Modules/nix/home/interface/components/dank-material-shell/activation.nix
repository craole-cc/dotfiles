{
  bins,
  inputs,
  templates,
  themes,
}: let
  inherit (inputs.home-manager.lib.hm.dag) entryAfter;
  inherit (themes) icons;
  activation = let
    inherit (bins) dirname dmsSet install jaq mkdir mktemp rm;
    inherit (templates) foot ghostty kitty;
  in
    entryAfter ["writeBoundary"] ''
      settings="$HOME/.config/DankMaterialShell/settings.json"
      foot_theme="$HOME/.config/foot/dank-colors.ini"
      ghostty_opacity="$HOME/.config/ghostty/dotdots-opacity"
      kitty_opacity="$HOME/.config/kitty/dotdots-opacity.conf"
      theme="${templates.catppuccin.pathStr}"
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
        $DRY_RUN_CMD ${install} -m 0644 ${foot.theme.fallback.source} "$foot_theme"
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
in
  activation
