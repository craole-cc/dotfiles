{
  mkGroup,
  mkEntry,
  fromJSON,
  ...
} @ args: let
  ai = import ./entries/ai.nix args;
in
  mkGroup {
    name = "ai-assistance";
    description = "AI Assistants";
    default = true;
    features =
      [
        (mkEntry {
          userSettings = fromJSON ''
            {
              "github.copilot.enable": {
                "*": true,
                "markdown": false,
                "nix": true,
                "plaintext": false,
                "powershell": false,
                "rust": false,
                "scminput": false,
                "shellscript": true
              },
              "github.copilot.chat.codesearch.enabled": true,
              "github.copilot.nextEditSuggestions.eagerness": "low",
              "github.copilot.nextEditSuggestions.enabled": true,
              "chat.experimental.stickyScroll.enabled": false,
              "chat.tools.terminal.autoApprove": {
                "awk": true,
                "cksum": true,
                "command": true,
                "nix": true,
                "printf": true,
                "zig": true
              },
              "chat.viewSessions.orientation": "stacked",
              "codeium.disableSupercomplete": true,
              "codeium.enableConfig": {
                "*": true,
                "cypher": true,
                "jsonc": true,
                "just": true,
                "markdown": true,
                "nix": true,
                "typst": true
              },
              "codeium.enableSearch": true,
              "continue.disableQuickFix": true,
              "continue.enableTabAutocomplete": true,
              "continue.showInlineTip": false,
              "geminicodeassist.chat.defaultCodeBlockDisplay": "Expanded",
              "geminicodeassist.inlineSuggestions.enableAuto": true,
              "geminicodeassist.updateChannel": "Insiders"
            }
          '';
        })
      ]
      ++ map (entry:
        entry
        // {
          userSettings = {};
          keybindings = [];
        }) [
        ai.entries.codeium
        ai.entries.copilot
        ai.entries.chatgpt
        ai.entries.continue
        ai.entries.gemini
      ];
  }
