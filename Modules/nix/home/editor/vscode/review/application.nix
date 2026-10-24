{
  mkGroup,
  mkEntry,
  ...
} @ args: let
  productivity = import ./entries/productivity.nix args;
in
  mkGroup {
    name = "global-application";
    description = "Global & Application";
    default = true;
    features =
      [
        (mkEntry {
          userSettings = builtins.fromJSON ''
            {
              "files.eol": "\n",
              "license.author": "Craig 'Craole' Cole",
              "license.default": "mit",
              "update.mode": "manual",
              "security.workspace.trust.untrustedFiles": "open",
              "window.customMenuBarAltFocus": true,
              "window.customTitleBarVisibility": "auto",
              "window.menuBarVisibility": "toggle",
              "window.restoreFullscreen": true,
              "window.titleBarStyle": "native",
              "window.zoomPerWindow": true,
              "vscode-default-keybindings.windowsKeybindings": true
            }
          '';
          # Merged from keybindings.jsonc: CONFIGURATION
          keybindings = builtins.fromJSON ''
            [
              {
                "key": "ctrl+shift+,",
                "command": "-editor.action.inPlaceReplace.up",
                "when": "editorTextFocus && !editorReadonly"
              },
              {
                "key": "ctrl+shift+,",
                "command": "workbench.action.openSettingsJson"
              },
              {
                "key": "ctrl+shift+alt+,",
                "command": "runCommands",
                "args": {
                  "commands": [
                    "workbench.action.openSettingsJson",
                    "workbench.action.openRawDefaultSettings",
                    "workbench.action.moveEditorToNextGroup"
                  ]
                }
              },
              {
                "key": "ctrl+alt+,",
                "command": "workbench.action.openGlobalKeybindingsFile"
              },
              {
                "key": "shift+alt+,",
                "command": "runCommands",
                "args": {
                  "commands": [
                    "workbench.action.openDefaultKeybindingsFile",
                    "workbench.action.openGlobalKeybindingsFile",
                    "workbench.action.moveEditorToNextGroup"
                  ]
                }
              }
            ]
          '';
        })
      ]
      ++ map (entry:
        entry
        // {
          userSettings = {};
          keybindings = [];
        }) [
        productivity.entries.keybindings
      ];
  }
