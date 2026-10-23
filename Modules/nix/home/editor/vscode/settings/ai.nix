{
  inputs,
  pkgs,
  mkMerge,
  flatten,
  mkVSCodeFeature,
  mkVSCodeSubFeature,
  ...
}: let
  features = [
    (mkVSCodeSubFeature {
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
    })

    (mkVSCodeSubFeature {
      enable = true;
      extensions = [
        "openai.chatgpt"
        "openai.codex-audio"
      ];
      userSettings = {};
    })

    (mkVSCodeSubFeature {
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
    })

    (mkVSCodeSubFeature {
      enable = false;
      extensions = [];
      userSettings = {
        "continue.telemetryEnabled" = false;
        "continue.disableQuickFix" = true;
        "continue.enableTabAutocomplete" = true;
        "continue.showInlineTip" = false;
      };
    })

    (mkVSCodeSubFeature {
      enable = false;
      extensions = [];
      userSettings = {
        "geminicodeassist.chat.defaultCodeBlockDisplay" = "Expanded";
        "geminicodeassist.inlineSuggestions.enableAuto" = true;
        "geminicodeassist.updateChannel" = "Insiders";
      };
    })
  ];
  # enabled = filter (feature: feature.enable) features;
in {
  name = "ai";
  description = "AI assistance extensions";
  default = true;
  feature = enable:
    mkVSCodeFeature {
      inherit enable pkgs inputs;
      extensions = flatten (map (feature: feature.extensions) features);
      userSettings = mkMerge (map (feature: feature.userSettings or {}) features);
      keybindings = flatten (map (feature: feature.keybindings or []) features);
    };
}
