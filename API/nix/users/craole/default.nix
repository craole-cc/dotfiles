{
  imports = [
    ./programs/common/rust.nix
    # ./programs
    # ./services
  ];

  description = "Craig 'Craole' Cole";

  password = "$6$2o3rjHVZgXEuyZ97$PtmQa1PIOmKb6dAwZ0mZJUulAkJoCfj.qjJHgtusfVnIIsHmENcA7q8PV9I2PveOwdEdFWwMBgLu3a5HZavXC1";

  git = [
    {
      id = "craole-cc";
      name = "craole-cc";
      email = "134658831+craole-cc@users.noreply.github.com";
      root = "craole-cc";
    }
    {
      id = "craole";
      name = "Craole";
      email = "32288735+Craole@users.noreply.github.com";
      root = "Craole";
    }
  ];

  capabilities = {
    writing = {};
    conferencing = {};
    development = {
      languages.rust = {
        channel = "nightly";
        components = [
          "rust-src"
          "rust-analyzer"
          "rustfmt"
          "clippy"
        ];
      };
    };
    creation = {};
    analysis = {};
    management = {};
    gaming = {};
    multimedia = {};
  };

  shells = [
    "bash"
    "nushell"
    "powershell"
  ];

  interface = {
    # displayProtocol = "wayland";
    # desktopEnvironment = "cosmic";
    # windowManager = "hyprland";
    # bar = "caelestia";
    # shell = "bash";
    # prompt = "starship";
    keyboard = {
      # modifier = "SUPER";
      swapCapsEscape = false;
      vimKeybinds = false;

      # # AI follows the schema's scratchpad role convention on the A key:
      # # primary = Super, secondary = Super+Shift, tertiary = Super+Alt.
      # scratchpads.ai = {
      #   key = "A";
      #   primary = {
      #     mod = ["SUPER"];
      #     command = "hermes-desktop";
      #   };
      #   secondary = {
      #     mod = ["SUPER" "SHIFT"];
      #     command = "claude-desktop";
      #   };
      #   tertiary = {
      #     mod = ["SUPER" "ALT"];
      #     command = "chatgpt";
      #   };
      # };

      # Scratchpad keys and role modifiers are schema-owned. Scratchpad
      # applications follow the normalized application roles below.

      #~@ Keybindings Map
      #? Define application/action keys agnostic of WM/DE
      # bindings = {
      #   #~@ Quick Launch
      #   launcher = {
      #     # primary = {
      #     # bind="Super";
      #     # command =
      #     # secondary = "Super+Space";
      #     # }
      #   };
      #   terminal = "Meta+Return";
      #   fileManager = "Meta+E";

      #   #~@ Quake/Scratchpad Terminals
      #   quake1 = "Meta+grave"; # Super + `
      #   quake2 = "Meta+Shift+grave"; # Super + ~

      #   #~@ Applications
      #   browser = {
      #     primary = "Meta+B";
      #     secondary = "Meta+Shift+B";
      #   };

      #   editor = {
      #     tty = {
      #       primary = "Meta+C";
      #       secondary = "Meta+Shift+C";
      #     };
      #     gui = {
      #       primary = "Meta+V";
      #       secondary = "Meta+Shift+V";
      #     };
      #   };

      #   #~@ Window Management
      #   closeWindow = "Meta+Q";
      #   fullscreen = "Meta+F";
      #   floating = "Meta+Space";

      #   #~@ Workspace Navigation
      #   workspace = {
      #     next = "Meta+Right";
      #     prev = "Meta+Left";
      #     # Or specific workspaces: "Meta+1" through "Meta+9"
      #   };

      #   #~@ System
      #   lock = "Meta+L";
      #   logout = "Meta+Shift+E";
      #   screenshot = "Print";
      #   screenshotArea = "Meta+Shift+S";

      #   #~@ Audio
      #   volumeUp = "XF86AudioRaiseVolume";
      #   volumeDown = "XF86AudioLowerVolume";
      #   volumeMute = "XF86AudioMute";

      #   #~@ Brightness
      #   brightnessUp = "XF86MonBrightnessUp";
      #   brightnessDown = "XF86MonBrightnessDown";
      # };
    };
  };

  desktops = [
    "plasma"
    "hyprland"
    "niri"
    # "mango"
    # "cosmic"
  ];

  theme = rec {
    palettes = {
      catppuccin = {
        frappe = rec {
          name = "Catppuccin Frappé";
          variant = "dark";
          description = "Soothing pastel theme, the low-contrast dark flavor.";
          author = "Catppuccin";
          license = "MIT";
          source = "https://github.com/catppuccin/catppuccin";
          colors = {
            rosewater = "#f2d5cf";
            flamingo = "#eebebe";
            pink = "#f4b8e4";
            mauve = "#ca9ee6";
            red = "#e78284";
            maroon = "#ea999c";
            peach = "#ef9f76";
            yellow = "#e5c890";
            green = "#a6d189";
            teal = "#81c8be";
            sky = "#99d1db";
            sapphire = "#85c1dc";
            blue = "#8caaee";
            lavender = "#babbf1";
            text = "#c6d0f5";
            subtext1 = "#b5bfe2";
            subtext0 = "#a5adce";
            overlay2 = "#949cbb";
            overlay1 = "#838ba7";
            overlay0 = "#737994";
            surface2 = "#626880";
            surface1 = "#51576d";
            surface0 = "#414559";
            base = "#303446";
            mantle = "#292c3c";
            crust = "#232634";
          };
          accent = colors.mauve;
          ansi = {
            regular = {
              inherit (colors) red green yellow blue;
              black = colors.surface1;
              magenta = colors.mauve;
              cyan = colors.teal;
              white = colors.subtext1;
            };
            bright = {
              black = colors.surface2;
              white = colors.text;
            };
          };
          background = colors.base;
          foreground = colors.text;
          muted = colors.subtext0;
          surface = colors.surface1;
        };
        latte = rec {
          name = "Catppuccin Latte";
          variant = "light";
          description = "Soothing pastel theme, the light flavor.";
          author = "Catppuccin";
          license = "MIT";
          source = "https://github.com/catppuccin/catppuccin";
          colors = {
            rosewater = "#dc8a78";
            flamingo = "#dd7878";
            pink = "#ea76cb";
            mauve = "#8839ef";
            red = "#d20f39";
            maroon = "#e64553";
            peach = "#fe640b";
            yellow = "#df8e1d";
            green = "#40a02b";
            teal = "#179299";
            sky = "#04a5e5";
            sapphire = "#209fb5";
            blue = "#1e66f5";
            lavender = "#7287fd";
            text = "#4c4f69";
            subtext1 = "#5c5f77";
            subtext0 = "#6c6f85";
            overlay2 = "#7c7f93";
            overlay1 = "#8c8fa1";
            overlay0 = "#9ca0b0";
            surface2 = "#acb0be";
            surface1 = "#bcc0cc";
            surface0 = "#ccd0da";
            base = "#eff1f5";
            mantle = "#e6e9ef";
            crust = "#dce0e8";
          };
          accent = colors.teal;
          ansi = {
            regular = {
              inherit (colors) red green yellow blue;
              black = colors.surface2;
              magenta = colors.pink;
              cyan = colors.teal;
              white = colors.subtext1;
            };
            bright = {
              black = colors.overlay0;
              white = colors.text;
            };
          };
          background = colors.base;
          foreground = colors.text;
          muted = colors.subtext0;
          surface = colors.surface2;
        };
      };
    };
    modes = rec {
      dark = {
        palette = palettes.catppuccin.frappe;
        icon = "buuf-nestort";
        cursor = "material-cursors";
        opacity.terminal = 0.92;
      };
      light = {
        palette = palettes.catppuccin.latte;
        icon = "candy-icons";
        cursor = "catppuccin-cursors";
        opacity.terminal = 0.88;
      };
      default = dark;
      autoSwitch = true;
    };
  };

  fonts = let
    #~@ Packages
    fira-code = {
      name = "Fira Code";
      package = "fira-code";
    };
    fira-code-nf = {
      name = "Fira Code Nerd Font";
      package = "nerd-fonts.fira-code";
    };
    ibm-plex-sans = {
      name = "IBM Plex Sans";
      package = "ibm-plex";
    };
    ibm-plex-serif = {
      name = "IBM Plex Serif";
      package = "ibm-plex";
    };
    jetbrains-mono = {
      name = "JetBrains Mono";
      package = "jetbrains-mono";
    };
    jetbrains-mono-nf = {
      name = "JetBrains Mono Nerd Font";
      package = "nerd-fonts.jetbrains-mono";
    };
    lilex = {
      name = "Lilex";
      package = "lilex";
    };
    lilex-nf = {
      name = "Lilex Nerd Font";
      package = "nerd-fonts.lilex";
    };
    maple-mono = {
      name = "Maple Mono";
      package = "maple-mono";
    };
    maple-mono-nf = {
      name = "Maple Mono NF";
      package = "maple-mono.NF-unhinted";
    };
    material-symbols-outlined = {
      name = "Material Symbols Outlined";
      package = "material-symbols";
    };
    material-symbols-rounded = {
      name = "Material Symbols Rounded";
      package = "material-symbols";
    };
    material-symbols-sharp = {
      name = "Material Symbols Sharp";
      package = "material-symbols";
    };
    monaspace-argon = {
      name = "Monaspace Argon Frozen";
      package = "monaspace";
    };
    monaspace-krypton = {
      name = "Monaspace Krypton Frozen";
      package = "monaspace";
    };
    monaspace-radon = {
      name = "Monaspace Radon Frozen";
      package = "monaspace";
    };
    noto-color-emoji = {
      name = "Noto Color Emoji";
      package = "noto-fonts-color-emoji";
    };
    noto-serif = {
      name = "Noto Serif";
      package = "noto-fonts";
    };
    noto-sans = {
      name = "Noto Sans";
      package = "noto-fonts";
    };
    overpass = {
      name = "Overpass";
      package = "overpass";
    };
    rubik = {
      name = "Rubik";
      package = "rubik";
    };
    source-code-pro = {
      name = "Source Code Pro";
      package = "source-code-pro";
    };
    source-code-pro-nf = {
      name = "Source Code Pro Nerd Font";
      package = "nerd-fonts.source-code-pro";
    };
    source-sans-pro = {
      name = "Source Sans Pro";
      package = "source-sans-pro";
    };
    source-serif-pro = {
      name = "Source Serif Pro";
      package = "source-serif-pro";
    };

    #~@ Categories
    clock = [
      rubik
      monaspace-krypton
      source-code-pro
    ];
    emoji =
      [noto-color-emoji] ++ material;
    material = [
      material-symbols-sharp
      material-symbols-outlined
      material-symbols-rounded
    ];
    monospace = [
      lilex-nf
      lilex
      maple-mono-nf
      maple-mono
      jetbrains-mono-nf
      jetbrains-mono
      fira-code-nf
      fira-code
      source-code-pro-nf
      source-code-pro
    ];
    sans = [
      monaspace-radon
      monaspace-argon
      ibm-plex-sans
      source-sans-pro
      overpass
      noto-sans
    ];
    serif = [
      ibm-plex-serif
      noto-serif
      source-serif-pro
    ];
  in {inherit clock sans serif emoji material monospace;};

  packages = {
    ai-agent = [
      "hermes-desktop"
      "chatgpt"
      "claude-code"
      "codex"
      "ollama"
    ];
    bar = ["dms"];
    browser = [
      "chromium"
      "zen-twilight"
      "brave"
    ];
    editor = [
      "helix"
      "neovim"
    ];
    explorer = [
      "yazi"
      "doublecmd"
    ];
    shell = [
      "bash"
      "nushell"
      "powershell"
      "zsh"
    ];
    coding = [
      "common"
      "nix"
      "markup"
      "rust"
      "python"
      "shellscript"
      "zig"
    ];
    common = [];
    extra = [
      "fastfetch"
      "imv"
      "obs-studio"
      "qimgv"
      "qbittorrent-enhanced"
    ];
    media = [
      "mpv"
      "freetube"
      "shortwave"
    ];
    ide = [
      "zed-editor-fhs"
      "vscode-fhs"
      "vscode-insiders"
    ];
    launcher = [
      "vicinae"
    ];
    prompt = [
      "starship"
    ];
    terminal = [
      "ghostty"
      "foot"
      "warp-terminal"
      "kitty"
    ];
  };

  keyboard = {
    layout = "us";
    variant = "";
    swapCapsEscape = false;
    vimKeybinds = false;
    bindings = let
      modifier = ["SUPER"];
    in {
      #~@ Applications
      launcher = let
        description = "Launcher";
        category = "application";
        key = "Space";
        shared = {inherit category description modifier key;};
      in [
        shared
        (
          shared
          // {
            description = description + ": Browse clipboard history";
            modifier = modifier ++ ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Search files";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      terminal = let
        description = "Terminal";
        key = "Grave";
        category = "application";
        shared = {inherit category description modifier key;};
      in [
        (
          shared
          // {description = description + ": Scrathpad";}
        )
        (
          shared
          // {
            description = description + ": Primary";
            modifier = modifier ++ ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Secondary";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      browser = let
        description = "Browser";
        key = "B";
        category = "application";
        shared = {inherit category description modifier key;};
      in [
        (
          shared
          // {description = description + ": Scrathpad";}
        )
        (
          shared
          // {
            description = description + ": Primary";
            modifier = modifier ++ ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Secondary";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      explorer = let
        description = "File Manager";
        key = "E";
        category = "application";
        shared = {inherit category description modifier key;};
      in [
        (shared // {description = description + ": Scrathpad";})
        (
          shared
          // {
            description = description + ": Primary";
            modifier = modifier ++ ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Secondary";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      editor = let
        description = "Editor";
        key = "C";
        category = "application";
        shared = {inherit category description modifier key;};
      in [
        (shared // {description = description + ": Scrathpad";})
        (
          shared
          // {
            description = description + ": Primary";
            modifier = modifier ++ ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Secondary";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      agent = let
        description = "Agent";
        category = "application";
        key = "A";
        shared = {inherit category description modifier key;};
      in [
        (shared // {description = description + ": Scrathpad";})
        (
          shared
          // {
            description = description + ": Primary";
            modifier = modifier ++ ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Secondary";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      #~@ System Control
      close = let
        description = "Exit";
        category = "controller";
        key = "Q";
        shared = {inherit category description modifier key;};
      in [
        (shared // {description = description + ": Application";})
        {
          inherit key;
          description = description + ": Session";
          modifier = modifier ++ ["Shift"];
        }
        {
          inherit key;
          description = description + ": System";
          modifier = modifier ++ ["Ctrl"];
        }
      ];

      lock = let
        description = "Lock";
        category = "controller";
        key = "L";
        shared = {inherit category description modifier key;};
      in [
        (shared // {description = description + ": Screen";})
        {
          inherit key;
          description = description + "Session";
          modifier = modifier ++ ["Ctrl"];
        }
        {
          inherit key;
          description = description + ": Application";
          modifier = modifier ++ ["Alt"];
        }
      ];

      window = let
        description = "Window";
        category = "controller";
        key = "F";
        shared = {inherit category description modifier key;};
      in [
        (shared // {description = description + ": Fullscreen";})
        (
          shared
          // {
            description = description + ": Floating";
            modifier = modifier ++ ["Shift"];
          }
        )
      ];

      workspaceNext = let
        description = "Workspace";
        category = "controller";
        key = "Right";
        shared = {inherit category description modifier key;};
      in [
        (
          shared
          // {description = description + ": Move focus right";}
        )
        (
          shared
          // {
            description = description + ": Move window right";
            modifier = modifier ++ ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Move to next workspace";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      workspacePrev = let
        description = "Workspace";
        category = "controller";
        key = "Left";
        shared = {inherit category description modifier key;};
      in [
        (
          shared
          // {description = description + ": Move focus left";}
        )
        (
          shared
          // {
            description = description + ": Move window left";
            modifier = modifier ++ ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Move to previous workspace";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      #~@ Audio
      volumeUp = let
        description = "Volume";
        category = "audio";
        key = "XF86AudioRaiseVolume";
        shared = {inherit category description key;};
      in [
        (
          shared
          // {description = description + ": Increase";}
        )
        (
          shared
          // {
            description = description + ": Increase incrementally";
            modifier = ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Increase exponentially";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      volumeDown = let
        description = "Volume";
        category = "audio";
        key = "XF86AudioLowerVolume";
        shared = {inherit category description key;};
      in [
        (
          shared
          // {description = description + ": Decrease";}
        )
        (
          shared
          // {
            description = description + ": Decrease incrementally";
            modifier = ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Decrease exponentially";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      volumeMute = let
        description = "Volume";
        category = "audio";
        key = "XF86AudioMute";
        shared = {inherit category description key;};
      in [
        (
          shared
          // {description = description + ": Mute or unmute";}
        )
      ];

      #~@ Brightness
      brightnessUp = let
        description = "Brightness";
        category = "display";
        key = "XF86MonBrightnessUp";
        shared = {inherit category description key;};
      in [
        (
          shared
          // {description = description + ": Increase";}
        )
        (
          shared
          // {
            description = description + ": Increase incrementally";
            modifier = ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Increase exponentially";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];

      brightnessDown = let
        description = "Brightness";
        category = "display";
        key = "XF86MonBrightnessDown";
        shared = {inherit category description key;};
      in [
        (
          shared
          // {description = description + ": Decrease";}
        )
        (
          shared
          // {
            description = description + ": Decrease incrementally";
            modifier = ["Shift"];
          }
        )
        (
          shared
          // {
            description = description + ": Decrease exponentially";
            modifier = modifier ++ ["Alt"];
          }
        )
      ];
    };
  };

  applications = {
    ai = {
      primary = "hermes-desktop";
      secondary = "chatgpt";
      tertiary = "claude-desktop";
    };

    browser = {
      primary = "zen-twilight";
      secondary = "chromium";
      tertiary = "brave";
    };

    editor = {
      tty = {
        primary = "helix";
        secondary = "neovim";
      };
      gui = {
        primary = "vscode";
        secondary = "zed";
        tertiary = "vscode-insiders";
      };
    };
    terminal = {
      primary = "ghostty";
      secondary = "foot";
      tertiary = "kitty";
    };
    explorer = {
      primary = "yazi";
      secondary = "doublecmd";
      tertiary = "dolphin";
    };
    launcher = {
      primary = "vicinae";
      secondary = "fuzzel";
    };
    # bar = "caelestia";
    bar = "dank";
    prompt = "starship";

    allowed = [
      # "atuin"
      "codex"
      "claude-code"
      "ollama"
      "fastfetch"
      "freetube"
      "ghostty"
      "kitty"
      "warp-terminal"
      "jujutsu"
      "obs-studio"
      "yazi"
      "vim"
      "vscode"
    ];

    utilities = {
      atuin.enable = true;
      bat.enable = true;
      btop.enable = true;
      clock.enable = true;
      direnv.enable = true;
      git.enable = true;
      gitui.enable = true;
      github.enable = true;
      grep.enable = true;
      home-manager.enable = true;
      jujutsu.enable = true;
      nh.enable = true;
      nix-index.enable = true;
      topgrade.enable = true;
      tmux.enable = true;
      yazi.enable = true;
      delta.enable = true;
    };
  };

  paths = rec {
    pics = "home:Pictures";
    dlds = "home:Downloads";
    avatars = {
      session = pics + "/avatar.jpg";
    };
    wallpapers = "home:Pictures/Wallpapers";
    # wallpapers = let
    #   all = [
    #     "dots:Assets/Images/wallpapers"
    #     (pics + "/Wallpapers")
    #   ];
    #   # primary = builtins.head all;
    #   # dark = primary + "/dark.jpg";
    #   # light = primary + "/light.jpg";
    # in {
    #   # inherit all primary dark light;
    #   # Example: Override specific monitor with custom wallpaper
    #   # monitors = {
    #   # "HDMI-A-3" = {
    #   #   dark = wallpapersDir + "/2560x1440/dark/ktc-special.jpg";
    #   #   light = wallpapersDir + "/2560x1440/light.jpg";
    #   # };
    #   #
    #   # Example: Use a directory for random selection
    #   # "DP-3" = {
    #   #   dark = wallpapersDir + "/1600x900/dark/";
    #   #   light = wallpapersDir + "/1600x900/light/";
    #   # };
    # };
  };
}
