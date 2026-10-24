_: {
  extensions = [
    #? Better Todo Tree leverages ripgrep to locate custom tags like TODO and FIXME across your workspace. Results are mapped into a dedicated tree view and highlighted directly within your open files. Click any node in the tree to snap your cursor straight to that line of code..
    "FanaticPythoner.better-todo-tree"
  ];

  settings = {
    #~@ TODO Tree
    better-todo-tree.general = {
      #> Set polling interval (seconds) for tree refresh after repository changes.
      #? 0 disables
      automaticGitRefreshInterval = 0;
      #> Create a debug channel in the Output view
      debug = false;
      #> Export path; env vars like ${HOME} are expanded and strftime applies. A .json extension exports as a JSON record
      exportPath = "~/better-todo-tree-%Y%m%d-%H%M.txt";
      #> Set periodic tree refresh interval (minutes);
      #? 0 disables
      periodicRefreshInterval = 0;
      #> Cursor position when revealing a todo: "start of line", "start of todo" or "end of todo"
      revealBehaviour = "start of todo";
      #? Folder to run the search in; empty means the workspace folder
      rootFolder = "";
      #? Editor schemes to scan; add vscode-userdata for settings files or output for output windows
      schemes = [
        "file"
        "ssh"
        "untitled"
        "vscode-notebook-cell"
      ];
      #? Show a badge in the activity bar with the total number of TODOs
      showActivityBarBadge = false;
      #? Show icons instead of tags in the status bar
      showIconsInsteadOfTagsInStatusBar = false;
      #? Scanning progress display: none, status bar, notification, tree or all
      showScanningProgress = "status bar";
      #? Status bar content: none, total, tags, top three or current file
      statusBar = "none";
      #? Status bar click action: cycle, reveal or toggle highlights
      statusBarClickBehaviour = "reveal";

      #> Object-valued setting: keep as a real attrset, do not flatten
      #? Group similar tags under one type, e.g. { FIX = ["FIXME" "FIXIT"]; }; every tag must also be in tags
      tagGroups = {};

      #? Tag list; if one tag starts with another, list the longer one first
      tags = [
        "BUG"
        "HACK"
        "FIXME"
        "TODO"
        "XXX"
        "[ ]"
        "[x]"
      ];
    };
  };
}
