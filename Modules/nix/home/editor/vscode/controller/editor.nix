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
      "key" = "ctrl+alt+9";
      "command" = "sortLines.sortLinesCaseInsensitive";
      "when" = "editorTextFocus && !editorReadonly";
    }
  ];
}
