_: {
  extensions = [
    #? Typo linter (typos-rs / typos-lsp)
    "tekumara.typos-vscode"
  ];

  settings = {
    typos = {
      #> Path to a custom `typos` config file. Combined with workspace
      #> config files; this one wins for overlapping keys. Empty = no
      #> override (workspace `.typos.toml` is still read).
      config = "";

      #> Diagnostic severity shown in the editor.
      #?  - Error:       Red squiggle
      #?  - Warning:     Yellow squiggle
      #?  - Information: Blue squiggle
      #?  - Hint:        Dots
      diagnosticSeverity = "Information";

      #> Server log verbosity (Output → Typos pane).
      #?  - error | warn | info | debug | trace
      logLevel = "warn";

      #> Path to the `typos-lsp` binary. Empty = bundled binary.
      path = "";

      #> LSP trace level. Debugging only.
      #?  - off:      No traces
      #?  - messages: Trace sent/received
      #?  - verbose:  Includes message content
      trace.server = "off";
    };
  };
}
