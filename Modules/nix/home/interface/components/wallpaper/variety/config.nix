{ config, lib, pkgs, ... }:
let
  cfg = config.programs.variety;
  home = config.home.homeDirectory;
  vlib = import ./lib.nix { inherit lib; };
  scripts = import ./scripts.nix {
    inherit pkgs lib;
    runtimeInputs = cfg.runtimeInputs;
  };

  q = lib.escapeShellArg;
  conf = "${cfg.profileDir}/variety.conf";
  keyPlaceholder = "@WALLHAVEN_API_KEY@";

  settings =
    import ./defaults.nix {
      inherit home;
      profileDir = cfg.profileDir;
    }
    // {
      change_on_start = cfg.change.onStart;
      change_enabled = cfg.change.enable;
      change_interval = cfg.change.interval;
      internet_enabled = cfg.internet;
      safe_mode = cfg.safeMode;

      set_wallpaper_script = "${scripts.setWallpaper}";
      get_wallpaper_script = "${scripts.getWallpaper}";

      download_folder = cfg.folders.downloaded;
      fetched_folder = cfg.folders.fetched;
      favorites_folder = cfg.folders.favorites;
      download_preference_ratio = cfg.downloadPreferenceRatio;
      quota_enabled = cfg.quota.enable;
      quota_size = cfg.quota.size;
      wallhaven_api_key = if cfg.wallhaven.apiKeyFile == null then "" else keyPlaceholder;

      wallpaper_auto_rotate = cfg.autoRotate;
      wallpaper_display_mode = cfg.displayMode;

      clipboard_enabled = cfg.clipboard.enable;
      clipboard_use_whitelist = cfg.clipboard.useWhitelist;
      clipboard_hosts = lib.concatStringsSep "," cfg.clipboard.hosts;

      icon = cfg.icon;
      copyto_enabled = cfg.copyTo.enable;
      copyto_folder = cfg.copyTo.folder;

      clock_enabled = cfg.clock.enable;
      clock_font = cfg.clock.font;
      clock_date_font = cfg.clock.dateFont;
      clock_filter = cfg.clock.filter;

      quotes_enabled = cfg.quotes.enable;
      change_lock_screen = cfg.lockScreen;
      sync_enabled = cfg.sync;
      stats_enabled = cfg.stats;
    }
    // cfg.extraSettings;

  confFile = pkgs.writeText "variety.conf" (vlib.render {
    inherit settings;
    inherit (cfg) sources filters;
  });

  installConf = ''
    run install -Dm644 ${confFile} ${q conf}
    ${lib.optionalString (cfg.wallhaven.apiKeyFile != null) ''
      if [ -z "''${DRY_RUN:-}" ]; then
        key="$(tr -d '\n' < ${q cfg.wallhaven.apiKeyFile})"
        sed -i "s|${keyPlaceholder}|$key|" ${q conf}
      fi
    ''}
  '';

  # With a named profile, wrap the binary so every call (keybinds, the
  # variety_next/previous/love helpers, the desktop entry) hits that profile.
  package =
    if cfg.profile == null then
      cfg.package
    else
      pkgs.symlinkJoin {
        name = "variety-profiled";
        paths = [ cfg.package ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          rm $out/bin/variety
          makeWrapper ${cfg.package}/bin/variety $out/bin/variety \
            --add-flags ${q "--profile ${cfg.profile}"}
        '';
        meta = (cfg.package.meta or { }) // { mainProgram = "variety"; };
      };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ package ];

    home.activation.varietyProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      if cfg.seedMode == "overwrite" then
        installConf
      else
        ''
          if [ ! -e ${q conf} ]; then
            ${installConf}
          fi
        ''
    );
  };
}
