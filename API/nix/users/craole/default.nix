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
      mkNF = {
        name,
        package,
      }: {
        name = "${name} Nerd Font";
        package = "nerd-fonts.${package}";
      };

      packages = {
        cinzel = {
          regular = {
            name = "Cinzel";
            package = "cinzel";
          };
          display = {
            name = "Cinzel Decorative";
            package = "cinzel";
          };
        };

        fira = let
          mk = variant: pkgSuffix: {
            name = "Fira ${variant}";
            package = "fira-${pkgSuffix}";
          };
          mono = mk "Code" "code";
          math = mk "Math" "math";
          sansSerif = mk "Sans" "sans";
          monoNF = mkNF mono;
        in {inherit math mono monoNF sansSerif;};

        ibm = let
          mk = variant: {
            name = "IBM Plex ${variant}";
            package = "ibm-plex";
          };
        in {
          mono = mk "Mono";
          math = mk "Math";
          sansSerif = mk "Sans";
          serif = mk "Serif";
        };

        jetbrains = let
          name = "JetBrains Mono";
          package = "jetbrains-mono";
        in {
          mono = {inherit name package;};
          monoNF = mkNF {inherit name package;};
        };

        lilex = let
          name = "Lilex";
          package = "lilex";
        in {
          mono = {inherit name package;};
          monoNF = mkNF {inherit name package;};
        };

        maple = let
          name = "Maple Mono";
          package = "maple-mono";
        in {
          mono = {inherit name package;};
          monoNF = {
            name = "${name} NF";
            package = "${package}.NF-unhinted";
          };
        };

        material = let
          mk = name: {
            name = "Material Symbols ${name}";
            package = "material-symbols";
          };
        in {
          outlined = mk "Outlined";
          rounded = mk "Rounded";
          sharp = mk "Sharp";
        };

        monaspace = let
          mk = name: {
            name = "Monaspace ${name}";
            package = "monaspace";
          };
        in {
          sansSerif = mk "Neon"; # Classic neo-grotesque sans-serif
          humanist = mk "Argon"; # Humanist sans-serif with a warm feel
          serif = mk "Xenon"; # Wedge-serif / slab hybrid style
          math = mk "Radon"; # Cursive, expressive script-like variant
          square = mk "Krypton"; # Sharp, mechanical square-sans aesthetic
        };

        noto = let
          mk = {
            variant,
            package ? "noto-fonts",
          }: {
            name = "Noto ${variant}";
            inherit package;
          };
        in {
          emoji = mk {
            variant = "Color Emoji";
            package = "noto-fonts-color-emoji";
          };
          math = mk {variant = "Math";};
          mono = mk {variant = "Mono";};
          music = mk {variant = "Music";};
          sansSerif = mk {variant = "Sans";};
          serif = mk {variant = "Serif";};
        };

        orbitron = {
          name = "Orbitron";
          package = "orbitron";
        };

        rubik = {
          name = "Rubik";
          package = "rubik";
        };

        sourcePro = let
          mk = {
            name ? "Source Code Pro",
            package ? "source-code-pro",
          }: {inherit name package;};
        in {
          mono = mk {};
          monoNF = mkNF (mk {});
          sansSerif = mk {
            name = "Source Sans Pro";
            package = "source-sans-pro";
          };
          serif = mk {
            name = "Source Serif Pro";
            package = "source-serif-pro";
          };
        };
      };

      categories = with packages; {
        clock = [
          cinzel.display
          orbitron
          rubik
          # monaspace.square
          # monaspace.math
        ];
        display = [
        ];
        emoji = [noto.emoji] ++ categories.material;
        material = with material; [
          sharp
          outlined
          rounded
        ];
        math = [
          fira.math
          # noto.math
          # monaspace.math
        ];
        monospace = [
          lilex.monoNF
          maple.monoNF
        ];
        music = [
          noto.music
        ];
        sansSerif = [
          fira.sansSerif
          rubik
          # noto.sansSerif
          # monaspace.sansSerif
        ];
        serif = [
          cinzel.serif
          # ibm.serif
          # noto.serif
          # monaspace.serif
          # monaspace.humanist
        ];
      };
    in
      {inherit packages categories;} // categories;

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
