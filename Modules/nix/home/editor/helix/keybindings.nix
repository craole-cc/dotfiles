{
  pkgs,
  lix,
  ...
}: let
  inherit (lix.attrsets.construction) optionalAttrs;
  isWindows = pkgs.stdenv.hostPlatform.isWindows;

  unixTempDirectory = ''$(printenv XDG_RUNTIME_DIR || printenv TMPDIR || echo "$HOME/.cache")'';
  unixChoiceFile = "${unixTempDirectory}/helix-yazi-choice";
  unixCwdFile = "${unixTempDirectory}/helix-yazi-cwd";
  unixYaziBindings = [
    ":sh mkdir -p \"${unixTempDirectory}\" && rm -f \"${unixChoiceFile}\" \"${unixCwdFile}\""
    ":insert-output yazi --chooser-file=\"${unixChoiceFile}\" --cwd-file=\"${unixCwdFile}\""
    ":sh printf '\\033[?1049h\\033[?2004h' > /dev/tty"
    ":cd %sh{cat \"${unixCwdFile}\"}"
    ":open %sh{cat \"${unixChoiceFile}\"}"
    ":set mouse false"
    ":set mouse true"
    ":redraw"
  ];

  windowsChoiceFile = "$env:TEMP\\helix-yazi-choice";
  windowsCwdFile = "$env:TEMP\\helix-yazi-cwd";
  windowsYaziBindings = [
    ":sh Remove-Item -Force -ErrorAction SilentlyContinue -LiteralPath \"${windowsChoiceFile}\", \"${windowsCwdFile}\""
    ":insert-output yazi.exe --chooser-file=\"${windowsChoiceFile}\" --cwd-file=\"${windowsCwdFile}\""
    ":cd %sh{(Get-Content -Raw -LiteralPath \"${windowsCwdFile}\").TrimEnd()}"
    ":open %sh{(Get-Content -Raw -LiteralPath \"${windowsChoiceFile}\").TrimEnd()}"
    ":set mouse false"
    ":set mouse true"
    ":redraw"
  ];
in
  {
    settings.keys = {
      normal = {
        space = {
          space = "file_picker_in_current_directory";
          A-d =
            if isWindows
            then [
              ":cd %sh{$env:DOTS}"
              "file_picker_in_current_directory"
            ]
            else [
              ":cd %sh{printenv DOTS}"
              "file_picker_in_current_directory"
            ];
          o =
            if isWindows
            then windowsYaziBindings
            else unixYaziBindings;
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
  // optionalAttrs isWindows {
    settings.editor.shell = ["powershell" "-NoProfile" "-Command"];
  }
