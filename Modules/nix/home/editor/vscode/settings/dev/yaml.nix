_: {
  extensions = [
    "bluebrown.yamlfmt"
    "redhat.vscode-yaml"
  ];

  settings = {
    "[yaml]" = {
      editor.defaultFormatter = "bluebrown.yamlfmt";
    };

    redhat.telemetry.enabled = false;
  };
}
