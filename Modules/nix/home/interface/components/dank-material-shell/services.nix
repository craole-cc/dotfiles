{
  config,
  sync,
}: {
  user = {
    services.dotdots-foot-dms-theme-reload = {
      Unit = {
        Description = "Apply DMS appearance to desktop and terminals";
        StartLimitIntervalSec = 0;
      };
      Service = {
        Type = "oneshot";
        ExecStart = sync;
      };
      Install.WantedBy = ["graphical-session.target"];
    };

    paths.dotdots-foot-dms-theme-reload = {
      Unit.Description = "Watch DMS appearance settings and terminal palettes";
      Path.PathChanged = [
        "${config.xdg.configHome}/DankMaterialShell/settings.json"
        "${config.xdg.stateHome}/DankMaterialShell/session.json"
        "%h/.config/foot/dank-colors.ini"
      ];
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
