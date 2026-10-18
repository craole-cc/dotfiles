{
  settings.keys = {
    normal = {
      space = {
        space = "file_picker_in_current_directory";
        A-d = [
          ":cd %sh{printenv DOTS}"
          "file_picker_in_current_directory"
        ];
        o = [
          ":sh rm -f \"$XDG_RUNTIME_DIR/helix-yazi-choice\" \"$XDG_RUNTIME_DIR/helix-yazi-cwd\""
          ":insert-output yazi --chooser-file=\"$XDG_RUNTIME_DIR/helix-yazi-choice\" --cwd-file=\"$XDG_RUNTIME_DIR/helix-yazi-cwd\""
          ":sh printf '\\033[?1049h\\033[?2004h' > /dev/tty"
          ":cd %sh{cat \"$XDG_RUNTIME_DIR/helix-yazi-cwd\"}"
          ":open %sh{cat \"$XDG_RUNTIME_DIR/helix-yazi-choice\"}"
          ":set mouse false"
          ":set mouse true"
          ":redraw"
        ];
      };
      "C-]" = "indent";
      C-s = ":write";
      C-S-esc = "extend_line";
      # C-S-o = ":config-open";
      # C-S-r = ":config-reload";
      # a = "move_char_left";
      # w = "move_line_up";
      A-j = [
        "extend_to_line_bounds"
        "delete_selection"
        "paste_after"
      ];
      A-k = [
        "extend_to_line_bounds"
        "delete_selection"
        "move_line_up"
        "paste_before"
      ];
      ret = [
        "open_below"
        "normal_mode"
      ];
      g.u = ":lsp-restart";
      esc = [
        "collapse_selection"
        "keep_primary_selection"
      ];
      A-e = [
        "collapse_selection"
        "keep_primary_selection"
      ];
      A-f = [
        "collapse_selection"
        "keep_primary_selection"
        ":format"
      ];
      A-w = [
        "collapse_selection"
        "keep_primary_selection"
        ":write"
      ];
      A-q = ":quit";
    };

    select = {
      A-e = [
        "collapse_selection"
        "keep_primary_selection"
        "normal_mode"
      ];
      A-f = [
        "collapse_selection"
        "keep_primary_selection"
        "normal_mode"
        ":format"
      ];
      A-w = [
        "collapse_selection"
        "keep_primary_selection"
        "normal_mode"
        ":write"
      ];
      A-q = [
        "normal_mode"
        ":quit"
      ];
    };

    insert = {
      A-space = "normal_mode";
      A-e = "normal_mode";
      A-f = [
        "normal_mode"
        ":format"
      ];
      A-w = [
        "normal_mode"
        ":write"
      ];
      A-q = [
        "normal_mode"
        ":quit"
      ];
    };
  };
}
