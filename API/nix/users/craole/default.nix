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
        components = ["rust-src" "rust-analyzer" "rustfmt" "clippy"];
      };
    };
    creation = {};
    analysis = {};
    management = {};
    gaming = {};
    multimedia = {};
  };

  packages = {
    ai-agent = [
      "hermes-desktop"
      "chatgpt"
      "claude-desktop"
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
      # "brave"
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
      # TODO: Re-add OBS Studio when it is needed again.
      # "obs-studio"
      "qimgv"
      "qbittorrent-enhanced"
    ];
    media = [
      "mpv"
      "freetube"
      "shortwave"
    ];
    ide = [
      "vscode-fhs"
      "zed-editor-fhs"
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
    wallpaper = [
      "variety"
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
      # "plasma"
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
      packages = {
        # fira = {
        #   name = "Fira Code";
        #   package = "fira-code";
        # };
        # fira-nf = {
        #   name = "Fira Code Nerd Font";
        #   package = "nerd-fonts.fira-code";
        # };
        ibm-mono = {
          name = "IBM Plex Mono";
          package = "ibm-plex";
        };
        ibm-math = {
          name = "IBM Plex Math";
          package = "ibm-plex";
        };
        ibm-sans = {
          name = "IBM Plex Sans";
          package = "ibm-plex";
        };
        ibm-serif = {
          name = "IBM Plex Serif";
          package = "ibm-plex";
        };
        # jetbrains = {
        #   name = "JetBrains Mono";
        #   package = "jetbrains-mono";
        # };
        # jetbrains-nf = {
        #   name = "JetBrains Mono Nerd Font";
        #   package = "nerd-fonts.jetbrains-mono";
        # };
        lilex = {
          name = "Lilex";
          package = "lilex";
        };
        lilex-nf = {
          name = "Lilex Nerd Font";
          package = "nerd-fonts.lilex";
        };
        maple = {
          name = "Maple Mono";
          package = "maple-mono";
        };
        maple-nf = {
          name = "Maple Mono NF";
          package = "maple-mono.NF-unhinted";
        };
        material-outlined = {
          name = "Material Symbols Outlined";
          package = "material-symbols";
        };
        material-rounded = {
          name = "Material Symbols Rounded";
          package = "material-symbols";
        };
        material-sharp = {
          name = "Material Symbols Sharp";
          package = "material-symbols";
        };
        # monaspace-argon = {
        #   name = "Monaspace Argon Frozen";
        #   package = "monaspace";
        # };
        # monaspace-krypton = {
        #   name = "Monaspace Krypton Frozen";
        #   package = "monaspace";
        # };
        # monaspace-radon = {
        #   name = "Monaspace Radon Frozen";
        #   package = "monaspace";
        # };
        noto-emoji = {
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
        noto-math = {
          name = "Noto Sans Math";
          package = "noto-fonts";
        };
        noto-mono = {
          name = "Noto Sans Mono";
          package = "noto-fonts";
        };
        # overpass = {
        #   name = "Overpass";
        #   package = "overpass";
        # };
        rubik = {
          name = "Rubik";
          package = "rubik";
        };
        # source-code-pro = {
        #   name = "Source Code Pro";
        #   package = "source-code-pro";
        # };
        # source-code-pro-nf = {
        #   name = "Source Code Pro Nerd Font";
        #   package = "nerd-fonts.source-code-pro";
        # };
        # source-sans-pro = {
        #   name = "Source Sans Pro";
        #   package = "source-sans-pro";
        # };
        # source-serif-pro = {
        #   name = "Source Serif Pro";
        #   package = "source-serif-pro";
        # };
      };

      categories = with packages; rec {
        math = [
          ibm-math
          noto-math
          rubik
          # monaspace-krypton
          # source-code-pro
        ];
        emoji = [noto-emoji] ++ material;
        material = [
          material-sharp
          material-outlined
          material-rounded
        ];
        monospace = [
          lilex-nf
          lilex
          maple-nf
          maple
          ibm-mono
          noto-mono
          # jetbrains-nf
          # jetbrains
          # fira-nf
          # fira
          # source-code-pro-nf
          # source-code-pro
        ];
        sans = [
          ibm-sans
          noto-sans
          rubik
          # monaspace-radon
          # monaspace-argon
          # source-sans-pro
          # overpass
        ];
        serif = [
          ibm-serif
          noto-serif
          # source-serif-pro
        ];
      };
    in
      packages // categories;

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

        # Plain, Shift (incremental) and Super+Alt (exponential) variants of one key
        mkScale = common: key: verb: let
          desc = common.description;
        in [
          (mkBinding common {
            inherit key;
            description = "${desc}: ${verb}";
          })
          (mkBinding common {
            inherit key;
            description = "${desc}: ${verb} incrementally";
            modifier = ["Shift"];
          })
          (mkBinding common {
            inherit key;
            description = "${desc}: ${verb} exponentially";
            modifier = modifier ++ ["Alt"];
          })
        ];
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

        terminalOpen = let
          description = "Open Terminal";
          key = "Return";
          category = "application";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Primary";
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Shift"];
          })
        ];

        terminal = let
          description = "Terminal";
          key = "Grave";
          category = "application";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Primary";
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Tertiary";
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
            description = description + ": Primary";
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Tertiary";
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
            description = description + ": Primary";
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Tertiary";
            modifier = modifier ++ ["Alt"];
          })
        ];

        editor = let
          description = "Code Editor";
          key = "C";
          category = "application";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Primary";
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Tertiary";
            modifier = modifier ++ ["Alt"];
          })
        ];

        ide = let
          description = "Integrated Development Environment";
          key = "V";
          category = "application";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {
            description = description + ": Primary";
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Tertiary";
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
            description = description + ": Primary";
          })
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Tertiary";
            modifier = modifier ++ ["Alt"];
          })
        ];

        media = let
          description = "Media";
          category = "application";
          key = "M";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {description = description + ": Primary";})
          (mkBinding common {
            description = description + ": Secondary";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = description + ": Tertiary";
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
            description = "${description}: Application";
            modifier = modifier ++ ["Ctrl"];
          })
          (mkBinding common {
            description = "${description}: Session";
            modifier = modifier ++ ["Ctrl" "Shift"];
          })
          (mkBinding common {
            description = "${description}: System";
            modifier = modifier ++ ["Ctrl" "Alt"];
          })
        ];

        lock = let
          description = "Lock";
          category = "controller";
          key = "L";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {description = "${description}: Screen";})
          (mkBinding common {
            description = "${description}: Session";
            modifier = modifier ++ ["Ctrl"];
          })
          (mkBinding common {
            description = "${description}: Application";
            modifier = modifier ++ ["Alt"];
          })
        ];

        window = let
          description = "Window";
          category = "controller";
          key = "F";
          common = {inherit category description modifier key;};
        in [
          (mkBinding common {description = "${description}: Fullscreen";})
          (mkBinding common {
            description = "${description}: Maximize/Restore";
            modifier = modifier ++ ["Shift"];
          })
          (mkBinding common {
            description = "${description}: Floating";
            modifier = modifier ++ ["Ctrl"];
          })
          (mkBinding common {
            description = "${description}: Maximise Column";
            modifier = modifier ++ ["Alt"];
          })
          (mkBinding common {
            description = "${description}: Switch Floating/Tiling Focus";
            modifier = modifier ++ ["Ctrl" "Shift"];
          })
          (mkBinding common {
            description = "${description}: Pin to All Workspaces";
            modifier = modifier ++ ["Ctrl" "Alt"];
          })
        ];

        workspace = let
          description = "Workspace";
          category = "controller";
          common = {inherit category description modifier;};
          mk = {
            key,
            dir,
            target,
          }: [
            (mkBinding common {
              inherit key;
              description = "${description}: Move focus ${dir}";
            })
            (mkBinding common {
              inherit key;
              description = "${description}: Move window ${dir}";
              modifier = modifier ++ ["Shift"];
            })
            (mkBinding common {
              inherit key;
              description = "${description}: Move to ${target} workspace";
              modifier = modifier ++ ["Alt"];
            })
          ];
        in
          mk {
            key = "Right";
            dir = "right";
            target = "next";
          }
          ++ mk {
            key = "Left";
            dir = "left";
            target = "previous";
          };

        #~@ Audio
        volume = let
          description = "Volume";
          category = "audio";
          common = {inherit category description;};
        in
          mkScale common "XF86AudioRaiseVolume" "Increase"
          ++ mkScale common "XF86AudioLowerVolume" "Decrease"
          ++ [
            (mkBinding common {
              description = "${description}: Mute or unmute";
              key = "XF86AudioMute";
            })
          ];

        #~@ Brightness
        brightness = let
          description = "Brightness";
          category = "display";
          common = {inherit category description;};
        in
          mkScale common "XF86MonBrightnessUp" "Increase"
          ++ mkScale common "XF86MonBrightnessDown" "Decrease";

        wallpaper = let
          description = "Wallpaper";
          category = "controller";
          common = {inherit category description;};
          altMod = modifier ++ ["Alt"];
          mod = altMod ++ ["Shift"];
        in [
          (mkBinding common {
            description = "${description}: Next";
            modifier = mod;
            key = "Period";
          })
          (mkBinding common {
            description = "${description}: Previous";
            modifier = mod;
            key = "Comma";
          })
          (mkBinding common {
            description = "${description}: Open";
            modifier = altMod;
            key = "W";
          })
          (mkBinding common {
            description = "${description}: Favourite";
            modifier = mod;
            key = "W";
          })
        ];
      };
    };
  };
}
