_: {
  extensions = [
    "codezombiech.gitignore"
    "GitHub.remotehub"
    "github.vscode-github-actions"
    "mhutchie.git-graph"
    "maciejdems.add-to-gitignore"
    "yy0931.gitconfig-lsp"
    "donjayamanne.githistory"
    "codezombiech.gitignore"
    "bluebrown.yamlfmt"
    "redhat.vscode-yaml"
  ];
  settings = {
    "[github-actions-workflow]" = {
      editor.defaultFormatter = "redhat.vscode-yaml";
    };
    git = {
      enabled = true;
      autofetch = true;
      autoStash = true;
      enableSmartCommit = true;
      openRepositoryInParentFolders = "always";
      rebaseWhenSync = true;
      allowForcePush = true;
      confirmForcePush = false;
      confirmSync = false;
      ignoreRebaseWarning = true;
    };

    yaml.disableSchemaDetection = [
      "**/.github/workflows/*.yml"
      "**/.github/workflows/*.yaml"
      "**/.gitea/workflows/*.yml"
      "**/.gitea/workflows/*.yaml"
      "**/.forgejo/workflows/*.yml"
      "**/.forgejo/workflows/*.yaml"
    ];
  };
  keybindings = [];
}
