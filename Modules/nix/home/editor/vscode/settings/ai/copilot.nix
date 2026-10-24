_: {
  extensions = [
    #? AI inline completions
    "github.copilot"
    #? AI chat assistant
    "github.copilot-chat"
  ];
  settings = {
    "github.copilot.enable" = {
      "*" = true;
      "plaintext" = false;
      "markdown" = false;
      "scminput" = false;
      "nix" = true;
      "shellscript" = true;
      "rust" = false;
      "powershell" = false;
    };
    "github.copilot.chat.codesearch.enabled" = true;
    "github.copilot.chat.editor.temporalContext.enabled" = true;
    "github.copilot.nextEditSuggestions.enabled" = true;
    "github.copilot.nextEditSuggestions.eagerness" = "low";
    "chat.experimental.stickyScroll.enabled" = false;
    "chat.tools.terminal.autoApprove" = {
      awk = true;
      cksum = true;
      command = true;
      nix = true;
      printf = true;
      zig = true;
    };
    "chat.viewSessions.orientation" = "stacked";
  };
}
