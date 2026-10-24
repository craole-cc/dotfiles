_: {
  enable = true;
  extensions = [
    "tombi-toml.tombi"
  ];
  settings = {
    "[toml]" = {
      "editor.suggest.showKeywords" = true;
      "editor.wordBasedSuggestions" = "off";
    };

    #? Arguments to `tombi` command.
    # "tombi.args" = [];

    #? Environment variables to pass to `tombi` command.
    # "tombi.env" = null;

    #? Absolute path to tombi executable.
    # "tombi.path" = null;

    #? Send semantic tokens for ordinary comments. Set to `false` to let TextMate grammars and other extensions highlight comments. Tombi directive and region keywords are always highlighted. Requires restarting the language server.
    "tombi.semanticTokens.comments.enabled" = true;

    #? Send semantic tokens for string values. Set to `false` to let TextMate grammars and other extensions highlight the inside of strings. Requires restarting the language server.
    "tombi.semanticTokens.strings.enabled" = true;
  };
  keybindings = [];
}
