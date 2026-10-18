{lix ? (import ../../.. {}).libraries.default}: let
  inherit (lix) lib;
  inherit (lix.attrsets.access) attrNames;
  inherit (lix.lists.access) length;
  inherit (lix.strings.predicates) hasInfix;

  binding = key: modifier: {inherit key modifier;};
  user = {
    packages = {
      terminal = ["ghostty"];
      editor = ["helix"];
      ide = ["vscode-fhs" "zed-editor-fhs"];
      ai-agent = ["hermes-desktop" "chatgpt"];
    };
    interface.keyboard.bindings = {
      editor = [(binding "C" ["SUPER"]) (binding "C" ["SUPER" "SHIFT"])];
      ide = [(binding "V" ["SUPER"]) (binding "V" ["SUPER" "SHIFT"])];
      agent = [(binding "A" ["SUPER"]) (binding "A" ["SUPER" "SHIFT"])];
    };
  };
  keyboard = lix.schema.io.mkKeyboard {
    host = {};
    inherit user;
  };
  apps = lix.schema.applications.mkApplications {
    host = {};
    inherit user;
  };
  lua = import ../../../Modules/nix/home/interface/manager/hyprland/applications.nix {
    inherit apps lix;
    inherit (keyboard) scratchpads;
  };
  contains = text: {
    expr = hasInfix text lua;
    expected = true;
  };
  tests = {
    testEditorChordSurvivesIdeDeclaration = contains ''hl.bind("SUPER + C",'';
    testSecondaryEditorChord = contains ''hl.bind("SUPER + SHIFT + C",'';
    testIdeChordSurvivesEditorDeclaration = contains ''hl.bind("SUPER + V",'';
    testSecondaryIdeChord = contains ''hl.bind("SUPER + SHIFT + V",'';
    testEditorUsesGuiSelection = contains ''workspace = "special:editor-primary", on_created_empty = "code --new-window"'';
    testIdeUsesGuiSelection = contains ''workspace = "special:ide-primary", on_created_empty = "code --new-window"'';
    testAgentPrimaryChord = contains ''hl.bind("SUPER + A",'';
    testAgentSecondaryChord = contains ''hl.bind("SUPER + SHIFT + A",'';
    testAgentPrimarySelection = contains ''workspace = "special:ai-primary", on_created_empty = "hermes-desktop"'';
    testAgentSecondarySelection = contains ''workspace = "special:ai-secondary", on_created_empty = "chatgpt"'';
    testEditorDoesNotLaunchTerminalEditor = {
      expr = hasInfix "ghostty -e hx" lua;
      expected = false;
    };
    testLegacyVisualUsesGuiSelection = {
      expr =
        (import ../../../Modules/nix/home/interface/manager/hyprland/settings/core.nix {
          inherit apps;
          keyboard.mod = "SUPER";
        })."$VISUAL";
      expected = "code";
    };
  };
in {
  total = length (attrNames tests);
  failures = lib.runTests tests;
}
