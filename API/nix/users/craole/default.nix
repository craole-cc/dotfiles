{
  imports = [
    # ./programs/common/rust.nix #TODO: Capabilities should handle this
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

  applications = {
    ai-agent = [
      "hermes-desktop"
      "chatgpt"
      "claude-code"
      "codex"
      "ollama"
    ];
    bar = [
      "dms"
      # "caelestia"
    ];
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

  interface = {
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

    keyboard = {
      layout = "us";
      variant = "";
      swapCapsEscape = false;
      vimKeybinds = false;
      bindings = let
        modifier = ["SUPER"];
        mkBinding = common: overrides:
          common
          // {
            modifier = overrides.modifier or (common.modifier or "");
            category = overrides.category or (common.category or "");
            description = overrides.description or (common.description or "");
            key = overrides.key or (common.key or "");
          };
      in {
        #~@ Applications
        launcher = let
          description = "Launcher";
          category = "application";
          key = "Space";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {})
          (mkBinding common {
            description = description + ": Browse clipboard history";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Search files";
            modifier = modifier ++ ["Alt"];
          })
        ];

        terminal = let
          description = "Terminal";
          key = "Grave";
          category = "application";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Scrathpad";
          })
          (mkBinding common {
            description = description + ": Primary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Alt"];
          })
        ];

        browser = let
          description = "Browser";
          key = "B";
          category = "application";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Scrathpad";
          })
          (mkBinding common {
            description = description + ": Primary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Alt"];
          })
        ];

        explorer = let
          description = "File Manager";
          key = "E";
          category = "application";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Scrathpad";
          })
          (mkBinding common {
            description = description + ": Primary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Alt"];
          })
        ];

        editor = let
          description = "Editor";
          key = "C";
          category = "application";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Scrathpad";
          })
          (mkBinding common {
            description = description + ": Primary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Alt"];
          })
        ];

        agent = let
          description = "Agent";
          category = "application";
          key = "A";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Scrathpad";
          })
          (mkBinding common {
            description = description + ": Primary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Alt"];
          })
        ];

        #~@ System Control
        close = let
          description = "Exit";
          category = "controller";
          key = "Q";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Application";
            modifier = modifier ++ ["Ctrl"];
          })
          (mkBinding common {
            description = description + ": Session";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": System";
            modifier = modifier ++ ["Ctrl" "Alt"];
          })
        ];

        lock = let
          description = "Lock";
          category = "controller";
          key = "L";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {description = description + ": Screen";})
          (mkBinding common {
            description = description + "Session";
            modifier = modifier ++ ["Ctrl"];
          })
          (mkBinding common {
            description = description + ": Application";
            modifier = modifier ++ ["Alt"];
          })
        ];

        window = let
          description = "Window";
          category = "controller";
          key = "F";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {description = description + ": Fullscreen";})
          (
            mkBinding common {
              description = description + ": Floating";
              modifier = modifier ++ ["Shift"];
            }
          )
        ];

        workspaceNext = let
          description = "Workspace";
          category = "controller";
          key = "Right";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Move focus right";
          })
          (mkBinding common {
            description = description + ": Move window right";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Move to next workspace";
            modifier = modifier ++ ["Alt"];
          })
        ];

        workspacePrev = let
          description = "Workspace";
          category = "controller";
          key = "Left";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Move focus left";
          })
          (mkBinding common {
            description = description + ": Move window left";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Move to previous workspace";
            modifier = modifier ++ ["Alt"];
          })
        ];

        #~@ Audio
        volumeUp = let
          description = "Volume";
          category = "audio";
          key = "XF86AudioRaiseVolume";
          common = {inherit category description key;};
        in [
          (mkBinding common {
            description = description + ": Increase";
          })
          (mkBinding common {
            description = description + ": Increase incrementally";
            modifier = ["Shift"];
          })
          (mkBinding common {
            description = description + ": Increase exponentially";
            modifier = modifier ++ ["Alt"];
          })
        ];

        volumeDown = let
          description = "Volume";
          category = "audio";
          key = "XF86AudioLowerVolume";
          common = {inherit category description key;};
        in [
          (mkBinding common {
            description = description + ": Decrease";
          })
          (mkBinding common {
            description = description + ": Decrease incrementally";
            modifier = ["Shift"];
          })
          (mkBinding common {
            description = description + ": Decrease exponentially";
            modifier = modifier ++ ["Alt"];
          })
        ];

        volumeMute = let
          description = "Volume";
          category = "audio";
          key = "XF86AudioMute";
          common = {inherit category description key;};
        in [
          (mkBinding common {
            description = description + ": Mute or unmute";
          })
        ];

        #~@ Brightness
        brightnessUp = let
          description = "Brightness";
          category = "display";
          key = "XF86MonBrightnessUp";
          common = {inherit category description key;};
        in [
          (mkBinding common {
            description = description + ": Increase";
          })
          (mkBinding common {
            description = description + ": Increase incrementally";
            modifier = ["Shift"];
          })
          (mkBinding common {
            description = description + ": Increase exponentially";
            modifier = modifier ++ ["Alt"];
          })
        ];

        brightnessDown = let
          description = "Brightness";
          category = "display";
          key = "XF86MonBrightnessDown";
          common = {inherit category description key;};
        in [
          (mkBinding common {
            description = description + ": Decrease";
          })
          (mkBinding common {
            description = description + ": Decrease incrementally";
            modifier = ["Shift"];
          })
          (mkBinding common {
            description = description + ": Decrease exponentially";
            modifier = modifier ++ ["Alt"];
          })
        ];
      };
    };
  };
}
