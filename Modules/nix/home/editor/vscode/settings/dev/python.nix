_: {
  extensions = [
    "charliermarsh.ruff"
    "fill-labs.dependi"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.vscode-python-envs"
    "formulahendry.code-runner"
  ];

  settings = {
    #~@ Semantic  Colour and style for TextMate scopes.
    editor.tokenColorCustomizations.textMateRules = [
      {
        scope = [
          "keyword.operator.logical.python"
        ];
        settings = {fontStyle = "italic";};
      }
    ];
  };
}
