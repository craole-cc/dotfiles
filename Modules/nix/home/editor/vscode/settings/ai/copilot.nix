_: {
  extensions = [
    #? AI inline completions
    "github.copilot"
    #? AI chat assistant
    "github.copilot-chat"
  ];
  settings = {
    github.copilot = {
      enable = {
        "*" = true;
        "plaintext" = false;
        "markdown" = false;
        "scminput" = false;
        "nix" = true;
        "shellscript" = true;
        "rust" = false;
        "powershell" = false;
      };

      chat = {
        codesearch.enabled = true;
        editor.temporalContext.enabled = true;
      };

      nextEditSuggestions = {
        enabled = true;
        eagerness = "low";
      };
    };

    chat = {
      experimental.stickyScroll.enabled = false;
      tools.terminal.autoApprove = {
        awk = true;
        cksum = true;
        command = true;
        nix = true;
        printf = true;
        zig = true;
      };
      viewSessions.orientation = "stacked";
    };
  };
}
