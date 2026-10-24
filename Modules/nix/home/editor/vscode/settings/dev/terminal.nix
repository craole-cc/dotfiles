_: {
  name = "terminal";
  description = "Terminal";
  settings = {
    "terminal.integrated.allowMnemonics" = true;
    "terminal.integrated.commandsToSkipShell" = [
      "workbench.action.terminal.copySelection"
    ];
    "terminal.integrated.confirmOnExit" = "never";
    "terminal.integrated.copyOnSelection" = true;
    "terminal.integrated.enableImages" = true;
    "terminal.integrated.enableMultiLinePasteWarning" = "never";
    "terminal.integrated.hideOnStartup" = "whenEmpty";
    "terminal.integrated.mouseWheelZoom" = false;
    "terminal.integrated.rightClickBehavior" = "copyPaste";
    "terminal.integrated.cursorBlinking" = true;
    "terminal.integrated.cursorStyle" = "block";
    "terminal.integrated.smoothScrolling" = true;
    "terminal.integrated.stickyScroll.enabled" = false;
    "terminal.integrated.tabs.location" = "right";
  };

  keybindings = [
    {
      "key" = "ctrl+j";
      "command" = "-workbench.action.togglePanel";
      "when" = "editorTextFocus && !editorReadonly";
    }
    {
      "key" = "ctrl+alt+`";
      "command" = "workbench.action.terminal.kill";
    }
    {
      "key" = "shift+escape";
      "command" = "workbench.action.terminal.kill";
      "when" = "terminalFocus";
    }
  ];
}
