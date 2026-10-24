{
  user,
  lix,
  cfg,
  context,
  mkEnable,
  requires,
  ...
}: let
  inherit (lix.lists.predicates) isIn;

  mod = "python";
  enable = cfg.python.enable;

  formatter = "charliermarsh.ruff";
in {
  inherit enable;
  options.python.enable = mkEnable {
    inherit context;
    condition = requires ["python" "python3"];
  };
  extensions = [
    formatter
    "fill-labs.dependi"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.vscode-python-envs"
    "formulahendry.code-runner"
  ];

  settings = {
    "[python]".editor.defaultFormatter = formatter;
    python.analysis.typeCheckingMode = "basic";
    #~@ Semantic  Colour and style for TextMate scopes.
    editor.tokenColorCustomizations.textMateRules = [
      {
        scope = ["keyword.operator.logical.python"];
        settings.fontStyle = "italic";
      }
    ];
  };
}
