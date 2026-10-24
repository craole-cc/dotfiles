_: {
  enable = true;
  extensions = [
    # "golang.Go"
  ];

  settings = {
    "[go]" = {
      editor = {
        insertSpaces = false;
        codeActionsOnSave.source.organizeImports = "explicit";
      };
    };

    #~@ Semantic  Colour and style for TextMate scopes.
    editor.tokenColorCustomizations.textMateRules = [
      {
        scope = [
          "source.go keyword.package.go"
          "source.go keyword.import.go"
          "source.go keyword.function.go"
          "source.go keyword.type.go"
          "source.go keyword.struct.go"
          "source.go keyword.interface.go"
          "source.go keyword.const.go"
          "source.go keyword.var.go"
          "source.go keyword.map.go"
          "source.go keyword.channel.go"
          "source.go keyword.control.go"
        ];
        settings.fontStyle = "italic";
      }
    ];
  };
}
