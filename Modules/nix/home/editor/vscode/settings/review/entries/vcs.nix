{
  mkGroup,
  mkEntry,
  ...
}: let
  git = mkEntry {
    enable = true;
    extensions = [
      #? .gitignore language support
      "codezombiech.gitignore"
      #? git log, file, line history
      "donjayamanne.githistory"
      #? visual git branch graph
      "mhutchie.git-graph"
      #? inline git blame
      "waderyan.gitblame"
      #? LSP for .gitconfig files
      "yy0931.gitconfig-lsp"
    ];
    userSettings = {
      "git.allowForcePush" = true;
      "git.autofetch" = true;
      "git.autoStash" = true;
      "git.confirmForcePush" = false;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "git.enabled" = true;
      "git.ignoreRebaseWarning" = true;
      "git.openRepositoryInParentFolders" = "always";
      "git.rebaseWhenSync" = true;
      "gitlens.currentLine.enabled" = false;
      "gitlens.hovers.currentLine.over" = "line";
    };
  };

  jujutsu = mkEntry {
    enable = false;
    extensions = [
      #? jujutsu VCS GUI
      "visualjj.visualjj"
      #? jujutsu keybindings
      "jjk.jjk"
    ];
  };
in {entries = {inherit git jujutsu;};}
