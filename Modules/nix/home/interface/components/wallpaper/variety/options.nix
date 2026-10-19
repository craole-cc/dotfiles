{
  config,
  lix,
  user,
  pkgs,
  context,
  wallpaper,
  tool,
  ...
}: let
  inherit (lix.lists.predicates) isIn;
  inherit (lix.options.construction) literalExpression mkOption mkEnable;
  inherit (lix.strings.predicates) hasPrefix;
  inherit (lix.types.combinators) attrsOf enum listOf nullOr oneOf submodule;
  inherit (lix.types.primitives) bool float package int ints str;

  cfg = config.programs.variety;
  home = config.home.homeDirectory;

  sourceType = submodule {
    options = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Whether this source is active.";
      };
      type = mkOption {
        type = str;
        example = "wallhaven";
        description = ''
          Variety source type: favorites, fetched, folder, bing, apod,
          earthview, unsplash, unsplash-search, wallhaven, artstation,
          flickr, ...
        '';
      };
      location = mkOption {
        type = str;
        example = "waterfalls";
        description = ''
          Depends on the type: a path, a URL, a search query, or just a
          label for sources that take no configuration.
        '';
      };
    };
  };

  filterType = submodule {
    options = {
      enable = mkOption {
        type = bool;
        default = false;
      };
      name = mkOption {type = str;};
      args = mkOption {
        type = str;
        default = "";
        description = "Arguments passed to ImageMagick.";
      };
    };
  };
in {
  options = {
    enable = mkEnable {
      inherit context;
      condition =
        wallpaper.cfg.enable
        && isIn "variety" (user.packages.wallpaper or []);
    };
    # enable = mkEnableOption "the Variety wallpaper manager, configured declaratively";

    package = mkOption {
      type = package;
      default = tool.defined.package;
      defaultText = literalExpression "pkgs.variety";
    };

    profile = mkOption {
      type = nullOr str;
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
      type = str;
      readOnly = true;
      description = "Resolved configuration folder of the profile.";
      default =
        if cfg.profile == null
        then "${home}/.config/variety"
        else if hasPrefix "/" cfg.profile
        then cfg.profile
        else "${config.xdg.configHome}/variety-profiles/${cfg.profile}";
    };

    seedMode = mkOption {
      type = enum ["overwrite" "ifMissing"];
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
      type = listOf package;
      default = [pkgs.coreutils pkgs.gnused pkgs.procps];
      description = ''
        Packages appended to PATH for the hook scripts. They are appended,
        so tools from your session (hyprctl, dms, swaybg) still win.
      '';
    };

    folders = {
      downloaded = mkOption {
        type = str;
        default = "${cfg.profileDir}/Downloaded";
      };
      fetched = mkOption {
        type = str;
        default = "${cfg.profileDir}/Fetched";
      };
      favorites = mkOption {
        type = str;
        default = "${cfg.profileDir}/Favorites";
      };
    };

    change = {
      onStart = mkOption {
        type = bool;
        default = true;
      };
      enable = mkOption {
        type = bool;
        default = true;
      };
      interval = mkOption {
        type = ints.between 5 31536000;
        default = 3600;
        description = "Seconds between wallpaper changes (minimum 5).";
      };
    };

    internet = mkOption {
      type = bool;
      default = true;
    };
    safeMode = mkOption {
      type = bool;
      default = false;
    };

    quota = {
      enable = mkOption {
        type = bool;
        default = true;
      };
      size = mkOption {
        type = ints.between 50 100000000;
        default = 1000;
        description = "Download folder size cap in MB (minimum 50).";
      };
    };

    downloadPreferenceRatio = mkOption {
      type = float;
      default = 0.9;
    };

    wallhaven.apiKeyFile = mkOption {
      type = nullOr str;
      default = null;
      example = "/run/secrets/wallhaven";
      description = ''
        Path (as a string, so it never enters the Nix store) to a file
        holding the Wallhaven API key. It is substituted into variety.conf
        at activation time. Use alphanumeric keys only.
      '';
    };

    displayMode = mkOption {
      type = enum [
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
      type = bool;
      default = true;
    };

    clipboard = {
      enable = mkOption {
        type = bool;
        default = false;
      };
      useWhitelist = mkOption {
        type = bool;
        default = true;
      };
      hosts = mkOption {
        type = listOf str;
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
      type = str;
      default = "Current";
      description = "Light, Dark, Current, 1-4, None, or a full image path.";
    };

    copyTo = {
      enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Copy each wallpaper to a world-readable folder (LightDM support).
          Leave off if that folder is also one of your sources, otherwise
          current wallpapers feed back into the pool.
        '';
      };
      folder = mkOption {
        type = str;
        default = "Default";
      };
    };

    clock = {
      enable = mkOption {
        type = bool;
        default = false;
      };
      font = mkOption {
        type = str;
        default = "Serif 70";
      };
      dateFont = mkOption {
        type = str;
        default = "Serif 30";
      };
      filter = mkOption {
        type = str;
        description = "ImageMagick arguments that draw the clock.";
        default = ''-density 100 -font `fc-match -f '%{file[0]}' '%CLOCK_FONT_NAME'` -pointsize %CLOCK_FONT_SIZE -gravity SouthEast -fill '#00000044' -annotate 0x0+[%HOFFSET+58]+[%VOFFSET+108] '%H:%M' -fill white -annotate 0x0+[%HOFFSET+60]+[%VOFFSET+110] '%H:%M' -font `fc-match -f '%{file[0]}' '%DATE_FONT_NAME'` -pointsize %DATE_FONT_SIZE -fill '#00000044' -annotate 0x0+[%HOFFSET+58]+[%VOFFSET+58] '%A, %B %d' -fill white -annotate 0x0+[%HOFFSET+60]+[%VOFFSET+60] '%A, %B %d' '';
      };
    };

    quotes.enable = mkOption {
      type = bool;
      default = false;
    };

    lockScreen = mkOption {
      type = bool;
      default = false;
      description = ''
        Maps to change_lock_screen. Variety's stock lock screen script only
        knows KDE and GNOME, so keep it off on Hyprland.
      '';
    };

    sync = mkOption {
      type = bool;
      default = false;
    };
    stats = mkOption {
      type = bool;
      default = false;
    };

    sources = mkOption {
      type = listOf sourceType;
      default = [];
      description = "Wallpaper sources, written as src1, src2, ... in order.";
    };

    filters = mkOption {
      type = listOf filterType;
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
      type = attrsOf (oneOf [bool int float str]);
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
