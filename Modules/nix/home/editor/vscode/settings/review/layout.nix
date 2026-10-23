{
  mkGroup,
  mkEntry,
  fromJSON,
  ...
}:
mkGroup {
  name = "layout";
  description = "Workbench & Layout";
  default = true;
  features = [
    (mkEntry {
      userSettings = fromJSON ''
        {
          "workbench.activityBar.location": "default",
          "workbench.panel.defaultLocation": "bottom",
          "workbench.sideBar.location": "right",
          "workbench.statusBar.visible": true,
          "breadcrumbs.enabled": true,
          "workbench.editor.empty.hint": "hidden",
          "workbench.editor.revealIfOpen": true,
          "workbench.editor.showTabs": "multiple",
          "workbench.startupEditor": "none",
          "workbench.commandPalette.preserveInput": true,
          "workbench.quickOpen.preserveInput": true,
          "workbench.experimental.share.enabled": true,
          "workbench.tree.enableStickyScroll": false,
          "extensions.ignoreRecommendations": true,
          "workbench.editor.useModal": "off"
        }
      '';
      keybindings = fromJSON ''
        [
          {
            "key": "ctrl+t ctrl+m",
            "command": "workbench.action.toggleMaximizedPanel"
          },
          {
            "key": "ctrl+0",
            "command": "runCommands",
            "args": {
              "commands": [
                "editor.action.fontZoomReset",
                "workbench.action.zoomReset"
              ]
            },
            "when": "editorTextFocus"
          },
          {
            "key": "ctrl+alt+z",
            "command": "toggle",
            "when": "editorTextFocus",
            "args": {
              "id": "zen",
              "value": [
                {
                  "breadcrumbs.enabled": true,
                  "editor.folding": true,
                  "editor.glyphMargin": true,
                  "editor.lineNumbers": "on",
                  "editor.minimap.enabled": true,
                  "editor.scrollbar.horizontal": "auto",
                  "editor.scrollbar.vertical": "auto",
                  "window.customTitleBarVisibility": "auto",
                  "workbench.activityBar.location": "default",
                  "workbench.editor.showTabs": "multiple",
                  "workbench.statusBar.visible": true
                },
                {
                  "breadcrumbs.enabled": false,
                  "editor.folding": false,
                  "editor.glyphMargin": false,
                  "editor.lineNumbers": "off",
                  "editor.minimap.enabled": false,
                  "editor.scrollbar.horizontal": "hidden",
                  "editor.scrollbar.vertical": "hidden",
                  "window.customTitleBarVisibility": "never",
                  "workbench.activityBar.location": "hidden",
                  "workbench.editor.showTabs": "none",
                  "workbench.statusBar.visible": false
                }
              ]
            }
          }
        ]
      '';
    })
  ];
}
