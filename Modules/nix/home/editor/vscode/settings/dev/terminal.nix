_: {
  name = "terminal";
  description = "Terminal";
  extensions = ["nguyenngoclong.terminal-keeper"];
  keybindings = [
    {
      key = "ctrl+j";
      command = "-workbench.action.togglePanel";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "ctrl+alt+`";
      command = "workbench.action.terminal.kill";
    }
    {
      key = "shift+escape";
      command = "workbench.action.terminal.kill";
      when = "terminalFocus";
    }
  ];

  settings = {
    terminal.integrated = {
      allowMnemonics = true;
      commandsToSkipShell = [
        "workbench.action.terminal.copySelection"
      ];
      confirmOnExit = "never";
      copyOnSelection = true;
      enableImages = true;
      enableMultiLinePasteWarning = "never";
      hideOnStartup = "whenEmpty";
      mouseWheelZoom = false;
      rightClickBehavior = "copyPaste";
      cursorBlinking = true;
      cursorStyle = "block";
      smoothScrolling = true;
      stickyScroll.enabled = false;
      tabs.location = "right";
    };
  };
}
