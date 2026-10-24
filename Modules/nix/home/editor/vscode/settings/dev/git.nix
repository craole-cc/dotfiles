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
      "editor.defaultFormatter" = "redhat.vscode-yaml";
    };
    "git.enabled" = true;
    "git.autofetch" = true;
    "git.autoStash" = true;
    "git.enableSmartCommit" = true;
    "git.openRepositoryInParentFolders" = "always";
    "git.rebaseWhenSync" = true;
    "git.allowForcePush" = true;
    "git.confirmForcePush" = false;
    "git.confirmSync" = false;
    "git.ignoreRebaseWarning" = true;

    "yaml.disableSchemaDetection" = [
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
