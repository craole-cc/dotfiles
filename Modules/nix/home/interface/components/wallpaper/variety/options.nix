{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.programs.variety;
  home = config.home.homeDirectory;

  sourceType = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether this source is active.";
      };
      type = mkOption {
        type = types.str;
        example = "wallhaven";
        description = ''
          Variety source type: favorites, fetched, folder, bing, apod,
          earthview, unsplash, unsplash-search, wallhaven, artstation,
          flickr, ...
        '';
      };
      location = mkOption {
        type = types.str;
        example = "waterfalls";
        description = ''
          Depends on the type: a path, a URL, a search query, or just a
          label for sources that take no configuration.
        '';
      };
    };
  };

  filterType = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      name = mkOption {type = types.str;};
      args = mkOption {
        type = types.str;
        default = "";
        description = "Arguments passed to ImageMagick.";
      };
    };
  };
in {
  options.programs.variety = {
    enable = mkEnableOption "the Variety wallpaper manager, configured declaratively";

    package = mkOption {
      type = types.package;
      default = pkgs.variety;
      defaultText = lib.literalExpression "pkgs.variety";
    };

    profile = mkOption {
      type = types.nullOr types.str;
      default = "declarative";
      example = "declarative";
      description = ''
        Variety profile. A bare name maps to
        ~/.config/variety-profiles/<name>, an absolute path is used as is,
        and null means the default ~/.config/variety. Unless null, the
        installed `variety` binary is wrapped so that every invocation
        (including `variety --next` from keybinds) targets this profile.
      '';
    };

    profileDir = mkOption {
      type = types.str;
      readOnly = true;
      description = "Resolved configuration folder of the profile.";
      default =
        if cfg.profile == null
        then "${home}/.config/variety"
        else if lib.hasPrefix "/" cfg.profile
        then cfg.profile
        else "${config.xdg.configHome}/variety-profiles/${cfg.profile}";
    };

    seedMode = mkOption {
      type = types.enum ["overwrite" "ifMissing"];
      default = "overwrite";
      description = ''
        overwrite: every switch rewrites variety.conf, so Nix is the source
        of truth (changes made in the Preferences dialog are lost).
        ifMissing: only write variety.conf when it does not exist yet.
        Variety rewrites the file itself when preferences change or on
        exit, so quit a running instance before switching.
      '';
    };

    runtimeInputs = mkOption {
      type = types.listOf types.package;
      default = [pkgs.coreutils pkgs.gnused pkgs.procps];
      description = ''
        Packages appended to PATH for the hook scripts. They are appended,
        so tools from your session (hyprctl, dms, swaybg) still win.
      '';
    };

    folders = {
      downloaded = mkOption {
        type = types.str;
        default = "${cfg.profileDir}/Downloaded";
      };
      fetched = mkOption {
        type = types.str;
        default = "${cfg.profileDir}/Fetched";
      };
      favorites = mkOption {
        type = types.str;
        default = "${cfg.profileDir}/Favorites";
      };
    };

    change = {
      onStart = mkOption {
        type = types.bool;
        default = true;
      };
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      interval = mkOption {
        type = types.ints.between 5 31536000;
        default = 3600;
        description = "Seconds between wallpaper changes (minimum 5).";
      };
    };

    internet = mkOption {
      type = types.bool;
      default = true;
    };
    safeMode = mkOption {
      type = types.bool;
      default = false;
    };

    quota = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      size = mkOption {
        type = types.ints.between 50 100000000;
        default = 1000;
        description = "Download folder size cap in MB (minimum 50).";
      };
    };

    downloadPreferenceRatio = mkOption {
      type = types.float;
      default = 0.9;
    };

    wallhaven.apiKeyFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/run/secrets/wallhaven";
      description = ''
        Path (as a string, so it never enters the Nix store) to a file
        holding the Wallhaven API key. It is substituted into variety.conf
        at activation time. Use alphanumeric keys only.
      '';
    };

    displayMode = mkOption {
      type = types.enum [
        "os"
        "smart"
        "zoom"
        "fill-with-black"
        "fill-with-blur"
        "gnome-zoom"
        "gnome-centered"
        "gnome-scaled"
        "gnome-stretched"
        "gnome-spanned"
        "gnome-wallpaper"
      ];
      default = "os";
      description = "Passed to the hook script as its fourth argument.";
    };

    autoRotate = mkOption {
      type = types.bool;
      default = true;
    };

    clipboard = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      useWhitelist = mkOption {
        type = types.bool;
        default = true;
      };
      hosts = mkOption {
        type = types.listOf types.str;
        default = [
          "wallhaven.cc"
          "wallpapers.net"
          "flickr.com"
          "imgur.com"
          "deviantart.com"
          "interfacelift.com"
          "vladstudio.com"
          "imageshack.us"
          "deviantart.net"
          "imageshack.com"
        ];
      };
    };

    icon = mkOption {
      type = types.str;
      default = "Current";
      description = "Light, Dark, Current, 1-4, None, or a full image path.";
    };

    copyTo = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Copy each wallpaper to a world-readable folder (LightDM support).
          Leave off if that folder is also one of your sources, otherwise
          current wallpapers feed back into the pool.
        '';
      };
      folder = mkOption {
        type = types.str;
        default = "Default";
      };
    };

    clock = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      font = mkOption {
        type = types.str;
        default = "Serif 70";
      };
      dateFont = mkOption {
        type = types.str;
        default = "Serif 30";
      };
      filter = mkOption {
        type = types.str;
        description = "ImageMagick arguments that draw the clock.";
        default = ''-density 100 -font `fc-match -f '%{file[0]}' '%CLOCK_FONT_NAME'` -pointsize %CLOCK_FONT_SIZE -gravity SouthEast -fill '#00000044' -annotate 0x0+[%HOFFSET+58]+[%VOFFSET+108] '%H:%M' -fill white -annotate 0x0+[%HOFFSET+60]+[%VOFFSET+110] '%H:%M' -font `fc-match -f '%{file[0]}' '%DATE_FONT_NAME'` -pointsize %DATE_FONT_SIZE -fill '#00000044' -annotate 0x0+[%HOFFSET+58]+[%VOFFSET+58] '%A, %B %d' -fill white -annotate 0x0+[%HOFFSET+60]+[%VOFFSET+60] '%A, %B %d' '';
      };
    };

    quotes.enable = mkOption {
      type = types.bool;
      default = false;
    };

    lockScreen = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Maps to change_lock_screen. Variety's stock lock screen script only
        knows KDE and GNOME, so keep it off on Hyprland.
      '';
    };

    sync = mkOption {
      type = types.bool;
      default = false;
    };
    stats = mkOption {
      type = types.bool;
      default = false;
    };

    sources = mkOption {
      type = types.listOf sourceType;
      default = [];
      description = "Wallpaper sources, written as src1, src2, ... in order.";
    };

    filters = mkOption {
      type = types.listOf filterType;
      description = "ImageMagick filters applied randomly to wallpapers.";
      default = [
        {
          name = "Keep original";
          args = "";
        }
        {
          name = "Grayscale";
          args = "-type Grayscale";
        }
        {
          name = "Heavy blur";
          args = "-scale 20% -blur 0x10 -resize 500%";
        }
        {
          name = "Soft blur";
          args = "-scale 20% -blur 0x2 -resize 500%";
        }
        {
          name = "Oil painting";
          args = "-paint 8";
        }
        {
          name = "Pointilism";
          args = "-spread 10 -noise 3";
        }
        {
          name = "Pixellate";
          args = "-scale 3% -scale 3333%";
        }
      ];
    };

    extraSettings = mkOption {
      type = types.attrsOf (types.oneOf [types.bool types.int types.float types.str]);
      default = {};
      example = {
        min_size_enabled = true;
        min_size = 80;
      };
      description = ''
        Any other top-level variety.conf key. These win over everything
        else, including defaults.nix.
      '';
    };
  };
}
