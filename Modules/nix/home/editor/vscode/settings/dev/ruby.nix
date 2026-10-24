_: {
  enable = false;

  extensions = [
    "LoranKloeze.ruby-rubocop-revived"
  ];

  settings = {
    "[ruby]" = {
      editor.defaultFormatter = "LoranKloeze.ruby-rubocop-revived";
    };
    rubyLsp.enableExperimentalFeatures = true;

    #~@ Semantic  Colour and style for TextMate scopes.
    editor.tokenColorCustomizations.textMateRules = [
      {
        scope = [
          "keyword.control.ruby"
          "keyword.control.module.ruby"
          "keyword.control.class.ruby"
          "keyword.control.def.ruby"
        ];
        settings.fontStyle = "italic";
      }
    ];
  };
}
