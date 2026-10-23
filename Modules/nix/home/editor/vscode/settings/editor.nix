{
  mkGroup,
  mkEntry,
  ...
} @ args: let
in
  mkGroup {
    name = "editor";
    description = "Editor";
    default = true;
    features = [
      (mkEntry {
        userSettings = builtins.fromJSON ''
          {
            "editor.detectIndentation": false,
            "editor.insertSpaces": true,
            "editor.tabSize": 2,
            "editor.wordWrap": "bounded",
            "editor.wordWrapColumn": 120,
            "editor.formatOnSave": true,
            "editor.formatOnSaveMode": "file",
            "diffEditor.ignoreTrimWhitespace": false,
            "editor.folding": true,
            "editor.glyphMargin": true,
            "editor.lineNumbers": "on",
            "editor.renderControlCharacters": false,
            "editor.renderLineHighlight": "gutter",
            "editor.renderWhitespace": "all",
            "editor.scrollbar.horizontal": "auto",
            "editor.scrollbar.vertical": "auto",
            "editor.unicodeHighlight.ambiguousCharacters": false,
            "diffEditor.codeLens": true,
            "editor.minimap.enabled": true,
            "editor.minimap.size": "fill",
            "editor.bracketPairColorization.independentColorPoolPerBracketType": true,
            "editor.guides.bracketPairs": "active",
            "editor.matchBrackets": false,
            "editor.occurrencesHighlight": "off",
            "editor.selectionHighlight": false,
            "editor.cursorBlinking": "expand",
            "editor.cursorSmoothCaretAnimation": "on",
            "editor.mouseWheelZoom": true,
            "editor.smoothScrolling": true,
            "editor.stickyScroll.defaultModel": "indentationModel",
            "editor.stickyScroll.enabled": false,
            "editor.stickyScroll.scrollWithEditor": false,
            "editor.inlayHints.enabled": "offUnlessPressed",
            "editor.inlineSuggest.suppressSuggestions": true,
            "editor.quickSuggestions": {
              "strings": "on"
            },
            "editor.suggestSelection": "recentlyUsedByPrefix",
            "editor.accessibilitySupport": "off",
            "editor.linkedEditing": true
          }
        '';
        # Merged from keybindings.jsonc: PINNED DEFAULTS, EDITOR
        keybindings = builtins.fromJSON ''
          [
            {
              "key": "alt+up",
              "command": "editor.action.moveLinesUpAction",
              "when": "editorTextFocus && !editorReadonly"
            },
            {
              "key": "alt+down",
              "command": "editor.action.moveLinesDownAction",
              "when": "editorTextFocus && !editorReadonly"
            },
            {
              "key": "ctrl+c",
              "command": "editor.action.clipboardCopyAction",
              "when": "textInputFocus"
            },
            {
              "key": "ctrl+alt+9",
              "command": "sortLines.sortLinesCaseInsensitive",
              "when": "editorTextFocus && !editorReadonly"
            }
          ]
        '';
      })
    ];
  }
