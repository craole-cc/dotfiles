{
  mkGroup,
  mkEntry,
  ...
} @ args: let
  decorations = import ./entries/decorations.nix args;
in
  mkGroup {
    name = "decorations";
    description = "Decorations";
    default = true;
    features =
      [
        (mkEntry {
          userSettings = builtins.fromJSON ''
            {
              "LWI.breakpoints": [
                {
                  "color": "rgb(0, 255, 0, 0.6)",
                  "column": 54
                },
                {
                  "color": "rgb(244, 180, 0,0.6)",
                  "column": 68
                },
                {
                  "color": "rgb(255, 0, 0, 0.6)",
                  "column": 79
                }
              ],
              "LWI.style.fontStyle": "italic",
              "LWI.style.fontWeight": "100",
              "render-special-chars.border": "1px solid; border-radius: 2px;",
              "render-special-chars.position": "before",
              "render-special-chars.updateDelay": 500,
              "render-special-chars.excludedSchemes": [
                "output",
                "debug",
                "git"
              ],
              "render-special-chars.include": [
                "0000-0008",
                "000B",
                "000C",
                "000E-001F",
                "007F-009F",
                "00A0-4DFF",
                "A000-10FFFF"
              ],
              "render-special-chars.except": [
                "0009",
                "000A",
                "000D",
                "0020-007E",
                "3105-3129",
                "4E00-9FFF",
                "：；，、。？！〜（）〈〉《》【】「」『』─"
              ],
              "colorful-comments-refreshed.tags": [
                {
                  "tag": "@",
                  "italic": true,
                  "backgroundColor": "#89a25722",
                  "color": "#89a257"
                },
                {
                  "tag": "~@",
                  "italic": true,
                  "backgroundColor": "#89a25722",
                  "color": "#89a257"
                },
                {
                  "tag": "!",
                  "backgroundColor": "transparent",
                  "color": "#ff0000"
                },
                {
                  "tag": "/",
                  "italic": true,
                  "backgroundColor": "#bd8af41a",
                  "color": "#bd8af4"
                },
                {
                  "tag": "|",
                  "italic": true,
                  "color": "hsl(148, 70%, 50%)"
                },
                {
                  "tag": "region",
                  "italic": true,
                  "backgroundColor": "#bd8af41a",
                  "color": "#bd8af4"
                },
                {
                  "tag": "endregion",
                  "italic": true,
                  "backgroundColor": "#bd8af41a",
                  "color": "#bd8af4"
                },
                {
                  "tag": "HELP",
                  "italic": true,
                  "backgroundColor": "transparent",
                  "color": "#fed200"
                },
                {
                  "tag": "shellcheck",
                  "italic": true,
                  "backgroundColor": "transparent",
                  "color": "#fd7b30"
                },
                {
                  "tag": "DOC ",
                  "italic": true,
                  "backgroundColor": "transparent",
                  "color": "#08c3d4"
                },
                {
                  "tag": "TOC ",
                  "italic": true,
                  "backgroundColor": "transparent",
                  "color": "#08c3d4"
                },
                {
                  "tag": "USAGE ",
                  "italic": true,
                  "backgroundColor": "transparent",
                  "color": "#08c3d4"
                },
                {
                  "tag": " http",
                  "italic": true,
                  "backgroundColor": "transparent",
                  "color": "#3498DB"
                },
                {
                  "tag": " -- ",
                  "bold": true,
                  "backgroundColor": "transparent",
                  "color": "#3498DB"
                },
                {
                  "tag": ".",
                  "bold": true,
                  "backgroundColor": "transparent",
                  "color": "#3498DB"
                },
                {
                  "tag": "result:",
                  "bold": true,
                  "backgroundColor": "transparent",
                  "color": "#3498DB"
                },
                {
                  "tag": "todo",
                  "italic": true,
                  "underline": true,
                  "backgroundColor": "transparent",
                  "color": "hsla(27, 90%, 55%, 0.75)"
                },
                {
                  "tag": "def",
                  "backgroundColor": "transparent",
                  "color": "hsla(43, 50%, 50%, 0.95)"
                },
                {
                  "tag": "=",
                  "backgroundColor": "transparent",
                  "color": "hsla(335, 80%, 38%, 0.75)"
                },
                {
                  "tag": "+",
                  "backgroundColor": "transparent",
                  "color": "hsla(335, 80%, 38%, 0.75)"
                },
                {
                  "tag": ">",
                  "bold": true,
                  "italic": true,
                  "underline": true,
                  "backgroundColor": "transparent",
                  "color": "hsla(162, 70%, 30%, 0.95)"
                },
                {
                  "tag": "?",
                  "bold": true,
                  "italic": true,
                  "underline": true,
                  "backgroundColor": "transparent",
                  "color": "hsla(162, 70%, 30%, 0.5)"
                },
                {
                  "tag": "╔",
                  "italic": true,
                  "backgroundColor": "hsla(300,86%,47%, 0.15)",
                  "color": "hsl(300,86%,47%)"
                },
                {
                  "tag": "║",
                  "italic": true,
                  "backgroundColor": "hsla(300,86%,47%, 0.15)",
                  "color": "hsl(300,86%,47%)"
                },
                {
                  "tag": "╠",
                  "italic": true,
                  "backgroundColor": "hsla(300,86%,47%, 0.15)",
                  "color": "hsl(300,86%,47%)"
                },
                {
                  "tag": "╚",
                  "italic": true,
                  "backgroundColor": "hsla(300,86%,47%, 0.15)",
                  "color": "hsl(300,86%,47%)"
                }
              ]
            }
          '';
        })
      ]
      ++ map (entry:
        entry
        // {
          userSettings = {};
          keybindings = [];
        }) [
        decorations.entries.errorLens
        decorations.entries.indentation
        decorations.entries.colorize
        decorations.entries.output
        decorations.entries.lineWidth
        decorations.entries.comments
        decorations.entries.todos
      ]
      ++ [
        (mkEntry {
          extensions = ["brandonkirbyson.vscode-animations"];
          userSettings = {
            "animations.Install-Method" = "Custom UI Style";
            "animations.CursorAnimation" = true;
            "animations.CursorAnimationOptions" = {
              Color = "teal";
              CursorStyle = "block";
              TrailLength = 8;
            };
          };
        })
        (mkEntry {
          extensions = [
            "subframe7536.custom-ui-style"
            "be5invis.vscode-custom-css"
            "illixion.vscode-vibrancy-continued"
          ];
          userSettings = with args.fonts.families; {
            "custom-ui-style.font.sansSerif" = sansSerif;
            "custom-ui-style.font.monospace" = monospace;
            "custom-ui-style.background.syncURL" = "file:///$\\{env:WALLPAPER\\}";
            "custom-ui-style.background.size" = "cover";
            "custom-ui-style.background.position" = "center";
            "custom-ui-style.background.opacity" = 0.94;
            "custom-ui-style.reloadWithoutPrompting" = true;
            "custom-ui-style.watch" = true;
          };
        })
      ];
  }
