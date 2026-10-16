sync: {
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
        "%h/.config/DankMaterialShell/settings.json"
        "%h/.config/foot/dank-colors.ini"
        "%h/.config/btop/btop.conf"
      ];
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
