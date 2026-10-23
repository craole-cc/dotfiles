{
  inputs,
  pkgs,
  mkMerge,
  flatten,
  mkVSCodeFeature,
  mkVSCodeSubFeature,
  ...
}: let
  copilot = mkVSCodeSubFeature {
    enabled = false;
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

  codeium = mkVSCodeSubFeature {
    enabled = false;
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
  codex = mkVSCodeSubFeature {
    enabled = false;
    extensions = [];
    userSettings = {};
  };
  gemini = mkVSCodeSubFeature {
    enabled = false;
    extensions = [];
    userSettings = {
      "geminicodeassist.chat.defaultCodeBlockDisplay" = "Expanded";
      "geminicodeassist.inlineSuggestions.enableAuto" = true;
      "geminicodeassist.updateChannel" = "Insiders";
    };
  };
  continue = mkVSCodeSubFeature {
    enabled = false;
    extensions = [];
    userSettings = {
      "continue.telemetryEnabled" = false;
      "continue.disableQuickFix" = true;
      "continue.enableTabAutocomplete" = true;
      "continue.showInlineTip" = false;
    };
  };
in {
  name = "ai";
  description = "AI assistance extensions";
  default = true;
  feature = enabled:
    mkVSCodeFeature {
      inherit enabled pkgs inputs;
      extensions = flatten [
        copilot.extensions
        codeium.extensions
        codex.extensions
        gemini.extensions
        continue.extensions
      ];
      userSettings = mkMerge [
        (copilot.userSettings or {})
        (codeium.userSettings or {})
        (codex.userSettings or {})
        (gemini.userSettings or {})
        (continue.userSettings or {})
      ];
    };
}
