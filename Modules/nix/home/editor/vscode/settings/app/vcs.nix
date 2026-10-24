_: {
  extensions = [
    "bluebrown.yamlfmt"
    "codezombiech.gitignore"
    "codezombiech.gitignore"
    "donjayamanne.githistory"
    "GitHub.remotehub"
    "github.vscode-github-actions"
    "jjk.jjk"
    "maciejdems.add-to-gitignore"
    "mhutchie.git-graph"
    "redhat.vscode-yaml"
    "visualjj.visualjj"
    "yy0931.gitconfig-lsp"
  ];
  settings = {
    "[github-actions-workflow]".editor.defaultFormatter = "redhat.vscode-yaml";
    "[properties]".editor.defaultFormatter = "yy0931.gitconfig-lsp";
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
}
