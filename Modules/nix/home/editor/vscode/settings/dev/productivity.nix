_: {
  extensions = [
    #? Better Todo Tree leverages ripgrep to locate custom tags like TODO and FIXME across your workspace. Results are mapped into a dedicated tree view and highlighted directly within your open files. Click any node in the tree to snap your cursor straight to that line of code..
    "FanaticPythoner.better-todo-tree"
  ];

  settings = {
    #~@ TODO Tree
    better-todo-tree.general = {
      automaticGitRefreshInterval = 0;
      debug = false;
      exportPath = "~/better-todo-tree-%Y%m%d-%H%M.txt";
      periodicRefreshInterval = 0;
      revealBehaviour = "start of todo";
      rootFolder = "";
      schemes = ["file" "ssh" "untitled" "vscode-notebook-cell"];
      showActivityBarBadge = false;
      showIconsInsteadOfTagsInStatusBar = false;
      showScanningProgress = "status bar";
      statusBar = "none";
      statusBarClickBehaviour = "reveal";

      # Object-valued setting: keep as a real attrset, do not flatten
      tagGroups = {};

      tags = [
        "BUG"
        "HACK"
        "FIXME"
        "TODO"
        "todo"
        "CHECK"
        "REVIEW"
        "XXX"
        "[ ]"
        "[x]"
      ];
    };
  };
}
