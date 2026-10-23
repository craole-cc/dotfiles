_: {
  keybindings = [
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
  ];
}
