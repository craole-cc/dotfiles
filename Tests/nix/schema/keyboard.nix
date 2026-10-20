{lix ? (import ../../.. {}).libraries.default}: let
  inherit (lix) lib;
  inherit (lix.attrsets.access) attrNames;
  inherit (lix.attrsets.construction) listToAttrs;
  inherit (lix.attrsets.transformation) mapAttrsToList;
  inherit (lix.lists.access) elemAt head length;
  inherit (lix.lists.construction) concatLists;
  inherit (lix.lists.transformation) imap0;
  inherit (lix.strings.construction) concatStringsSep splitString toJSON;
  inherit (lix.strings.predicates) hasInfix;

  # Keys, modifiers and package order come from the actual API declaration.
  user = import ../../../API/nix/users/craole;
  declared = (lix.schema.io.normalizeKeyboard user.interface.keyboard).bindings;
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
  # Check each keyboard category against its own declared package group.
  groups = {
    editor = {
      workspace = "editor";
      packages = apps.editor;
    };
    ide = {
      workspace = "ide";
      packages = apps.ide;
    };
    agent = {
      workspace = "ai";
      packages = apps.ai-agent;
    };
  };
  ranks = ["primary" "secondary" "tertiary"];
  primaryTerminal = head apps.terminal;
  terminalHost.interface.windowManager = "hyprland";
  terminalLua = terminals: let
    requested = user // {packages = user.packages // {terminal = terminals;};};
    interface = lix.schema.ui.mkUI {
      host = terminalHost;
      user = requested;
    };
    keyboard = lix.modules.home.control.mkKeyboard {
      host = terminalHost;
      user = requested // {inherit interface;};
    };
  in
    import ../../../Modules/nix/home/interface/manager/hyprland/bindings.nix {
      inherit keyboard lix;
      ghosttyEnabled = false;
    };
  terminalChord = binding: concatStringsSep " + " ((splitString " " binding.mod) ++ [binding.key]);
  terminalChecks = listToAttrs (imap0 (index: binding: {
      name = "testTerminalOpen${toString (index + 1)}";
      value = {
        expr = hasInfix ''hl.bind(${toJSON (terminalChord binding)}, hl.dsp.exec_cmd(${toJSON (elemAt apps.terminal index).command})'' (terminalLua user.packages.terminal);
        expected = true;
      };
    })
    declared.terminalOpen);
  checks = listToAttrs (concatLists (mapAttrsToList (group: spec:
    concatLists (imap0 (index: binding: let
        suffix =
          if index < length ranks
          then elemAt ranks index
          else toString (index + 1);
        workspace = "${spec.workspace}-${suffix}";
        chord = concatStringsSep " + " ((splitString " " binding.mod) ++ [binding.key]);
        entry =
          if index < length spec.packages
          then elemAt spec.packages index
          else null;
        command =
          if entry == null
          then null
          else entry.launch.scratchpad or entry.command;
        wrapped =
          if entry == null
          then null
          else if entry.needsTerminal
          then "${primaryTerminal.command} ${primaryTerminal.wrap.execFlag or "-e"} ${command}"
          else command;
      in [
        {
          name = "test${group}Chord${toString (index + 1)}";
          value = {
            expr = hasInfix ''hl.bind(${toJSON chord}, hl.dsp.workspace.toggle_special(${toJSON workspace})'' lua;
            expected = entry != null;
          };
        }
        {
          name = "test${group}Selection${toString (index + 1)}";
          value = {
            expr = hasInfix ''workspace = ${toJSON "special:${workspace}"}, on_created_empty = ${toJSON wrapped}'' lua;
            expected = entry != null;
          };
        }
      ])
      declared.${group}))
  groups));
  tests =
    checks
    // terminalChecks
    // {
      testTerminalOpenMissingSecondaryIsOmitted = {
        expr = hasInfix ''hl.bind(${toJSON (terminalChord (elemAt declared.terminalOpen 1))},'' (terminalLua [(head user.packages.terminal)]);
        expected = false;
      };
      testLegacyVisualUsesGuiSelection = {
        expr =
          (import ../../../Modules/nix/home/interface/manager/hyprland/settings/core.nix {
            inherit apps;
            keyboard.mod = keyboard.modifier;
          })."$VISUAL";
        expected = (head apps.ide).command;
      };
    };
in {
  total = length (attrNames tests);
  failures = lib.runTests tests;
}
