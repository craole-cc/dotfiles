_: {
  name = "editor";
  description = "Editor";
  enable = true;

  keybindings = [
    {
      key = "alt+up";
      command = "editor.action.moveLinesUpAction";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "alt+down";
      command = "editor.action.moveLinesDownAction";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "ctrl+c";
      command = "editor.action.clipboardCopyAction";
      when = "textInputFocus";
    }
    {
      key = "ctrl+alt+9";
      command = "sortLines.sortLinesCaseInsensitive";
      when = "editorTextFocus && !editorReadonly";
    }
  ];

  settings = {
    editor = {
      detectIndentation = false;
      insertSpaces = true;
      tabSize = 2;
      wordWrap = "bounded";
      wordWrapColumn = 120;
      formatOnSave = true;
      formatOnSaveMode = "file";
      folding = true;
      glyphMargin = true;
      lineNumbers = "on";
      renderControlCharacters = false;
      renderLineHighlight = "gutter";
      renderWhitespace = "all";
      scrollbar = {
        horizontal = "auto";
        vertical = "auto";
      };
      unicodeHighlight.ambiguousCharacters = false;
      minimap = {
        enabled = true;
        size = "fill";
      };
      bracketPairColorization.independentColorPoolPerBracketType = true;
      guides.bracketPairs = "active";
      matchBrackets = false;
      occurrencesHighlight = "off";
      selectionHighlight = false;
      cursorBlinking = "expand";
      cursorSmoothCaretAnimation = "on";
      mouseWheelZoom = true;
      smoothScrolling = true;
      stickyScroll = {
        defaultModel = "indentationModel";
        enabled = false;
        scrollWithEditor = false;
      };
      inlayHints.enabled = "offUnlessPressed";
      inlineSuggest.suppressSuggestions = true;
      quickSuggestions.strings = "on";
      suggestSelection = "recentlyUsedByPrefix";
      accessibilitySupport = "off";
      linkedEditing = true;
    };

    diffEditor = {
      ignoreTrimWhitespace = false;
      codeLens = true;
    };
  };
}
