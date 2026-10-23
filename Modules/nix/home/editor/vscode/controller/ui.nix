_: {
  keybindings = [
    {
      "key" = "ctrl+j";
      "command" = "-workbench.action.togglePanel";
    }
    {
      "key" = "ctrl+t ctrl+m";
      "command" = "workbench.action.toggleMaximizedPanel";
    }
    {
      "key" = "ctrl+0";
      "command" = "runCommands";
      "args" = {
        "commands" = [
          "editor.action.fontZoomReset"
          "workbench.action.zoomReset"
        ];
      };
      "when" = "editorTextFocus";
    }
    {
      "key" = "ctrl+alt+z";
      "command" = "toggle";
      "when" = "editorTextFocus";
      "args" = {
        "id" = "zen";
        "value" = [
          {
            "breadcrumbs.enabled" = true;
            "editor.folding" = true;
            "editor.glyphMargin" = true;
            "editor.lineNumbers" = "on";
            "editor.minimap.enabled" = true;
            "editor.scrollbar.horizontal" = "auto";
            "editor.scrollbar.vertical" = "auto";
            "window.customTitleBarVisibility" = "auto";
            "workbench.activityBar.location" = "default";
            "workbench.editor.showTabs" = "multiple";
            "workbench.statusBar.visible" = true;
          }
          {
            "breadcrumbs.enabled" = false;
            "editor.folding" = false;
            "editor.glyphMargin" = false;
            "editor.lineNumbers" = "off";
            "editor.minimap.enabled" = false;
            "editor.scrollbar.horizontal" = "hidden";
            "editor.scrollbar.vertical" = "hidden";
            "window.customTitleBarVisibility" = "never";
            "workbench.activityBar.location" = "hidden";
            "workbench.editor.showTabs" = "none";
            "workbench.statusBar.visible" = false;
          }
        ];
      };
    }
    {
      "key" = "ctrl+alt+.";
      "command" = "extension.toggleFiles";
    }
  ];
}
