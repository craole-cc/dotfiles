{
  mkGroup,
  mkEntry,
  ...
}: let
  codeium = mkEntry {
    enable = false;
    extensions = [
      #? alternative AI completions
      "codeium.codeium"
    ];
    userSettings = {
      "codeium.disableSupercomplete" = true;
      "codeium.enableSearch" = true;
      "codeium.enableConfig" = {
        "*" = true;
        "nix" = true;
        "jsonc" = true;
        "just" = true;
        "markdown" = true;
        "typst" = true;
        "cypher" = true;
      };
    };
  };

  chatgpt = mkEntry {
    enable = true;
    extensions = [
      "openai.chatgpt"
      "openai.codex-audio"
    ];
    userSettings = {};
  };

  copilot = mkEntry {
    enable = true;
    extensions = [
      #? AI inline completions
      "github.copilot"
      #? AI chat assistant
      "github.copilot-chat"
    ];
    userSettings = {
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
  };

  continue = mkEntry {
    enable = false;
    extensions = [];
    userSettings = {
      "continue.telemetryEnabled" = false;
      "continue.disableQuickFix" = true;
      "continue.enableTabAutocomplete" = true;
      "continue.showInlineTip" = false;
    };
  };

  gemini = mkEntry {
    enable = false;
    extensions = [];
    userSettings = {
      "geminicodeassist.chat.defaultCodeBlockDisplay" = "Expanded";
      "geminicodeassist.inlineSuggestions.enableAuto" = true;
      "geminicodeassist.updateChannel" = "Insiders";
    };
  };
in
  mkGroup {
    name = "ai";
    description = "AI assistance extensions";
    default = true;
    features = [codeium copilot chatgpt continue gemini];
  }
