# Global keybindings copied from the current VS Code user profile.
_: {
  keybindings = [
    {
      "key" = "alt+up";
      "command" = "editor.action.moveLinesUpAction";
      "when" = "editorTextFocus && !editorReadonly";
    }
    {
      "key" = "alt+down";
      "command" = "editor.action.moveLinesDownAction";
      "when" = "editorTextFocus && !editorReadonly";
    }
    {
      "key" = "ctrl+c";
      "command" = "editor.action.clipboardCopyAction";
      "when" = "textInputFocus";
    }
    {
      "key" = "ctrl+shift+,";
      "command" = "-editor.action.inPlaceReplace.up";
      "when" = "editorTextFocus && !editorReadonly";
    }
    {
      "key" = "ctrl+shift+,";
      "command" = "workbench.action.openSettingsJson";
    }
    {
      "key" = "ctrl+shift+alt+,";
      "command" = "runCommands";
      "args" = {
        "commands" = [
          "workbench.action.openSettingsJson"
          "workbench.action.openRawDefaultSettings"
          "workbench.action.moveEditorToNextGroup"
        ];
      };
    }
    {
      "key" = "ctrl+alt+,";
      "command" = "workbench.action.openGlobalKeybindingsFile";
    }
    {
      "key" = "shift+alt+,";
      "command" = "runCommands";
      "args" = {
        "commands" = [
          "workbench.action.openDefaultKeybindingsFile"
          "workbench.action.openGlobalKeybindingsFile"
          "workbench.action.moveEditorToNextGroup"
        ];
      };
    }
    {
      "key" = "ctrl+alt+9";
      "command" = "sortLines.sortLinesCaseInsensitive";
      "when" = "editorTextFocus && !editorReadonly";
    }
    {
      "key" = "ctrl+j";
      "command" = "-workbench.action.togglePanel";
    }
    {
      "key" = "ctrl+alt+`";
      "command" = "workbench.action.terminal.kill";
    }
    {
      "key" = "shift+escape";
      "command" = "workbench.action.terminal.kill";
      "when" = "terminalFocus";
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
