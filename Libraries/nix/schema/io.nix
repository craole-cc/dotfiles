{_, ...}: let
  inherit (_.attrsets.access) attrValues;
  inherit (_.lists.selection) filter;
  inherit (_.lists.construction) toList;
  inherit (_.strings.construction) concatStringsSep;
  inherit (_.options.construction) mkOption mkEnableOption;
  inherit (_.types.primitives) bool int str;
  inherit (_.types.combinators) attrsOf either listOf nullOr submodule;

  __exports = {
    internal =
      composites
      // {
        inherit
          defaults
          normalizeKeyboard
          mergeKeyboards
          mkKeyboard
          mkKeybindings
          ;
        keyboardDefaults = defaults.keyboard;
        mkHyprKeybindings = mkKeybindings.hyprland;
      };
    external = {
      mkKeyboardSchema = mkKeyboard;
    };
  };

  inherit (import ./keyboard.nix {inherit _;}) mergeKeyboards normalizeKeyboard;

  composites = {
    #~@ Types
    types = rec {
      keybinding = submodule {
        options = {
          modifier = mkOption {
            description = "Modifier alias, normalised to mod at the schema boundary";
            type = nullOr (either str (listOf str));
            default = null;
          };
          description = mkOption {
            description = "Description shown in keyboard help";
            type = str;
            default = "";
          };
          category = mkOption {
            description = "Keyboard binding category";
            type = str;
            default = "";
          };
          kind = mkOption {
            description = "Binding dispatch kind";
            type = str;
            default = "exec";
          };
          application = mkOption {
            description = "One-based application position; omitted positions follow the binding order";
            type = nullOr int;
            default = null;
          };
          command = mkOption {
            description = "Optional scratchpad command override";
            type = nullOr str;
            default = null;
          };
          release = mkOption {
            description = "Run the binding on key release";
            type = bool;
            default = false;
          };
          nonConsuming = mkOption {
            description = "Allow the application to receive the key";
            type = bool;
            default = false;
          };
          action = mkOption {
            type = nullOr str;
            default = null;
          };
          mod = mkOption {
            type = nullOr (either str (listOf str));
            default = null;
          };
          key = mkOption {
            type = nullOr str;
            default = null;
          };
        };
      };

      scratchpadRole = submodule {
        options = {
          description = mkOption {
            description = "Scratchpad binding description";
            type = str;
            default = "";
          };
          application = mkOption {
            description = "One-based application position; omitted positions follow the binding order";
            type = nullOr int;
            default = null;
          };
          key = mkOption {
            description = "Optional key override for an indexed scratchpad";
            type = nullOr str;
            default = null;
          };
          mod = mkOption {
            type = nullOr (either str (listOf str));
            default = null;
          };
          command = mkOption {
            description = "Optional command override for this scratchpad role";
            type = nullOr str;
            default = null;
          };
        };
      };

      scratchpad = submodule {
        options = {
          entries = mkOption {
            description = "Scratchpad overrides keyed by one-based application position";
            type = attrsOf scratchpadRole;
            default = {};
          };
          key = mkOption {
            type = nullOr str;
            default = null;
          };
          primary = mkOption {
            type = scratchpadRole;
            default = {};
          };
          secondary = mkOption {
            type = scratchpadRole;
            default = {};
          };
          tertiary = mkOption {
            type = scratchpadRole;
            default = {};
          };
        };
      };

      keyboard = submodule {
        options = {
          layout = mkOption {
            description = "Keyboard layout";
            type = str;
            default = "us";
          };
          variant = mkOption {
            description = "Keyboard layout variant";
            type = str;
            default = "";
          };
          modifier = mkOption {
            type = either str (listOf str);
            default = "";
          };
          swapCapsEscape = mkEnableOption "Swap CapsLock with Escape";
          vimKeybinds = mkEnableOption "Vim-style hjkl navigation bindings";
          bindings = mkOption {
            type = attrsOf (either keybinding (listOf keybinding));
            description = "Named bindings; ordered records address the matching application positions";
            default = {};
          };
          unbind = mkOption {
            description = "Inherited compositor bindings to remove";
            type = listOf keybinding;
            default = [];
          };
          scratchpads = mkOption {
            type = attrsOf scratchpad;
            default = {};
          };
        };
      };
    };
  };

  mod = ["SUPER"];

  # Scratchpad role modifiers are normalized exactly like the rest of the
  # keyboard schema. Categories own only their base key; role selection adds
  # SHIFT/ALT consistently across terminals, editors, browsers, and explorers.
  mkScratchpad = key: {
    inherit key;
    primary.mod = mod;
    secondary.mod = mod ++ ["SHIFT"];
    tertiary.mod = mod ++ ["ALT"];
  };

  defaults = {
    keyboard = {
      modifier = concatStringsSep " " mod;
      swapCapsEscape = true;
      unbind = [
        {
          inherit mod;
          key = "Q";
        }
      ];

      scratchpads = {
        terminal = mkScratchpad "grave";
        editor = mkScratchpad "C";
        browser = mkScratchpad "B";
        ai = mkScratchpad "A";
        media = mkScratchpad "M";
        explorer = mkScratchpad "E";
      };

      bindings = {
        # ── Applications ─────────────────────────────────────────────────────────
        terminal = {
          inherit mod;
          key = "RETURN";
          action = "$TERMINAL";
        };
        terminalSec = {
          mod = mod ++ ["SHIFT"];
          key = "Grave";
          action = "$TERMINAL_SEC";
        };
        browser = {
          inherit mod;
          key = "B";
          action = "$BROWSER";
        };
        browserSec = {
          mod = mod ++ ["SHIFT"];
          key = "B";
          action = "$BROWSER_SEC";
        };
        code = {
          inherit mod;
          key = "C";
          action = "code";
        };
        visual = {
          inherit mod;
          key = "V";
          action = "$VISUAL";
        };
        visualSec = {
          mod = mod ++ ["SHIFT"];
          key = "V";
          action = "$VISUAL_SEC";
        };
        fileManager = {
          inherit mod;
          key = "E";
          action = "$FILE_MANAGER";
        };
        fileManagerSec = {
          mod = mod ++ ["SHIFT"];
          key = "E";
          action = "$FILE_MANAGER_SEC";
        };
        launcher = {
          inherit mod;
          key = "SUPER_L";
          action = "$LAUNCHER";
        };
        launcherSec = {
          mod = mod ++ ["SHIFT"];
          key = "SPACE";
          action = "$LAUNCHER_SEC";
        };

        # ── Window state ─────────────────────────────────────────────────────────
        #? action = "" means the WM must override - these are WM dispatch commands
        close = {
          mod = mod ++ ["CTRL"];
          key = "Q";
          action = "";
        };
        fullscreen = {
          mod = ["ALT"];
          key = "RETURN";
          action = "";
        };
        maximise = {
          mod = mod ++ ["SHIFT"];
          key = "M";
          action = "";
        };
        float = {
          mod = mod ++ ["SHIFT"];
          key = "F";
          action = "";
        };
        pin = {
          mod = mod ++ ["CTRL"];
          key = "F";
          action = "";
        };
        split = {
          inherit mod;
          key = "S";
          action = "";
        };
        pseudo = {
          inherit mod;
          key = "P";
          action = "";
        };
        groupToggle = {
          inherit mod;
          key = "G";
          action = "";
        };
        groupLock = {
          inherit mod;
          key = "T";
          action = "";
        };

        # ── Navigation ───────────────────────────────────────────────────────────
        workspacePrev = {
          inherit mod;
          key = "TAB";
          action = "";
        };
        windowCycle = {
          mod = ["ALT"];
          key = "TAB";
          action = "";
        };
        windowCycleReverse = {
          mod = ["ALT" "SHIFT"];
          key = "TAB";
        };
        windowCycleRelease = [
          {
            mod = ["ALT"];
            key = "ALT_L";
            release = true;
            nonConsuming = true;
          }
          {
            mod = ["ALT"];
            key = "ALT_R";
            release = true;
            nonConsuming = true;
          }
        ];
        ghosttyQuickTerminal = {
          mod = ["ALT"];
          key = "grave";
          kind = "global";
          action = "com.mitchellh.ghostty:ALT+grave";
          description = "Toggle Ghostty quick terminal";
        };
        windowLast = {
          mod = [
            "ALT"
            "CTRL"
          ];
          key = "TAB";
          action = "";
        };

        # ── System ───────────────────────────────────────────────────────────────
        lock = {
          inherit mod;
          key = "L";
          action = "loginctl lock-session";
        };
        logout = {
          mod = mod ++ ["CTRL"];
          key = "L";
          action = "loginctl terminate-session self";
        };
        sleep = {
          mod = mod ++ ["CTRL"];
          key = "S";
          action = "systemctl suspend";
        };
        reboot = {
          mod = mod ++ ["CTRL"];
          key = "R";
          action = "systemctl reboot";
        };
        reboot_soft = {
          mod =
            mod
            ++ [
              "CTRL"
              "SHIFT"
            ];
          key = "R";
          action = "systemctl soft-reboot";
        };
        shutdown = {
          mod = mod ++ ["CTRL"];
          key = "Q";
          action = "systemctl poweroff";
        };

        # ── Screenshots ──────────────────────────────────────────────────────────
        screenshot = {
          mod = [];
          key = "PRINT";
          action = "";
        };
        screenshotRegion = {
          inherit mod;
          key = "PRINT";
          action = "";
        };
        screenshotWindow = {
          mod = mod ++ ["SHIFT"];
          key = "PRINT";
          action = "";
        };

        # ── Media ────────────────────────────────────────────────────────────────
        mediaPlay = {
          mod = [];
          key = "XF86AudioPlay";
          action = "playerctl play-pause";
        };
        mediaPrev = {
          mod = [];
          key = "XF86AudioPrev";
          action = "playerctl previous";
        };
        mediaNext = {
          mod = [];
          key = "XF86AudioNext";
          action = "playerctl next";
        };

        # ── Audio ────────────────────────────────────────────────────────────────
        volumeUp = {
          mod = [];
          key = "XF86AudioRaiseVolume";
          action = "wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+";
        };
        volumeDown = {
          mod = [];
          key = "XF86AudioLowerVolume";
          action = "wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-";
        };
        volumeMute = {
          mod = [];
          key = "XF86AudioMute";
          action = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        micMute = {
          mod = [];
          key = "XF86AudioMicMute";
          action = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        # ── Backlight ────────────────────────────────────────────────────────────
        brightnessUp = {
          mod = [];
          key = "XF86MonBrightnessUp";
          action = "brightnessctl set +5%";
        };
        brightnessDown = {
          mod = [];
          key = "XF86MonBrightnessDown";
          action = "brightnessctl set 5%-";
        };
      };
    };
  };

  mkKeyboard = {
    host,
    user ? {},
  }:
    mergeKeyboards [
      defaults.keyboard
      (host.keyboard or {})
      ((host.defaults.interface or (host.interface or {})).keyboard or {})
      (user.keyboard or {})
      (user.interface.keyboard or {})
    ];

  mkKeybindings = {
    hyprland = kb:
      map (b: "${b.mod}, ${b.key}, exec, ${b.action}") (
        filter (
          b:
            (b.mod or null)
            != null
            && (b.key or null) != null
            && (b.action or null) != null
            && (b.action or "") != ""
        ) (_.lists.aggregation.concatMap toList (attrValues kb.bindings))
      );
  };
in
  __exports.internal // {__rootAliases = __exports.external;}
