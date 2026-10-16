{
  bins,
  config,
  inputs,
  lix,
  pkgs,
}: let
  inherit (inputs.home-manager.lib.hm.dag) entryAfter;
  inherit (lix.attrsets.transformation) filterAttrs mapAttrs;
  inherit (lix.modules.construction) mkIf;
  inherit (lix.strings.transformation) escapeShellArg;
  inherit (bins) install jaq mkdir mktemp rm;

  cfg = config.programs.dank-material-shell;
  enabled = filterAttrs (_: plugin: plugin.enable) cfg.plugins;
  flags = (pkgs.formats.json {}).generate "dms-enabled-plugins.json" (
    mapAttrs (_: _: {enabled = true;}) enabled
  );
in
  mkIf (!cfg.managePluginSettings) (entryAfter ["configureDmsTheme"] ''
    settings=${escapeShellArg "${config.xdg.configHome}/DankMaterialShell/plugin_settings.json"}
    if [ -n "$DRY_RUN_CMD" ]; then
      echo "Would enable declared DMS plugins in $settings"
    else
      if [ -L "$settings" ]; then
        echo "Refusing to replace managed DMS plugin settings symlink: $settings" >&2
        exit 1
      fi
      ${mkdir} -p ${escapeShellArg "${config.xdg.configHome}/DankMaterialShell"}
      tmp="$(${mktemp} "$settings.tmp.XXXXXX")"
      trap '${rm} -f "$tmp"' EXIT
      if [ -f "$settings" ]; then
        ${jaq} --slurpfile declared ${flags} '. * $declared[0]' "$settings" > "$tmp"
      else
        ${jaq} '.' ${flags} > "$tmp"
      fi
      ${install} -m 0600 "$tmp" "$settings"
      ${rm} -f "$tmp"
      trap - EXIT
    fi
  '')
