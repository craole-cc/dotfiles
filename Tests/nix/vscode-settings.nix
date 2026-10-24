{lix ? (import ../.. {}).libraries.default}: let
  inherit (lix) lib;
  inherit (lix.applications.editors) flattenVSCodeSetting mkVSCodeSubFeature normalizeSettings;
  inherit (lix.modules.construction) mkForce mkIf mkMerge;

  baseline = builtins.fromJSON (builtins.readFile ../../Configuration/vscode/settings.json);
  settingNames = builtins.attrNames baseline;
  flatten = flattenVSCodeSetting {inherit settingNames;};
  entry = path:
    (mkVSCodeSubFeature ((import path {})
      // {
        enable = true;
        inherit settingNames;
      })).userSettings;
  nixSettings = entry ../../Modules/nix/home/editor/vscode/settings/dev/nix.nix;
  javascript = entry ../../Modules/nix/home/editor/vscode/settings/dev/js.nix;
  python = entry ../../Modules/nix/home/editor/vscode/settings/dev/python.nix;
  resolveProfile = features:
    (import ../../Modules/nix/home/editor/vscode/settings {
      inherit lix;
      inputs = {};
      pkgs = {};
      cfg.features = features;
      json.type = lib.types.json;
      fonts.families.monospace = "monospace";
      paths.store.cfg.default = ../../Configuration;
    }).output;
  enabledProfile = resolveProfile {
    ai = true;
    dev = true;
    doc = true;
    ui = true;
  };
  disabledProfile = resolveProfile {
    ai = false;
    dev = false;
    doc = false;
    ui = false;
  };
  profile = enabledProfile.userSettings;
  terminalBinding = {
    key = "ctrl+alt+`";
    command = "workbench.action.terminal.kill";
  };
  evaluate = value:
    (lib.evalModules {
      modules = [
        {
          options.settings = lib.mkOption {type = lib.types.json;};
          config.settings = value;
        }
      ];
    }).config.settings;

  checks = {
    disabledEntriesDoNotFallBackToJSON = builtins.all (name: !(builtins.hasAttr name profile)) [
      "harper.dialect"
      "codeium.enableSearch"
      "continue.enableTabAutocomplete"
      "geminicodeassist.inlineSuggestions.enableAuto"
      "rubyLsp.enableExperimentalFeatures"
      "terminal.integrated.profiles.windows"
    ];
    disabledGroupsDoNotFallBackToJSON = builtins.all (name: !(builtins.hasAttr name disabledProfile.userSettings)) [
      "[nix]"
      "nix.serverSettings"
      "workbench.iconTheme"
      "github.copilot.enable"
      "harper.dialect"
    ];
    unrelatedJSONSettingsPreserved = profile."editor.wordWrap" == baseline."editor.wordWrap";
    enabledEntryKeybindingIsNotDuplicated =
      builtins.length (builtins.filter (binding: binding == terminalBinding) enabledProfile.keybindings) == 1;
    disabledGroupKeybindingsDoNotFallBackToJSON = !(builtins.elem terminalBinding disabledProfile.keybindings);
    disabledGroupsHaveNoKeybindings = disabledProfile.keybindings == [];
    profilePassesSettingNamesToEntries =
      profile."nix.serverSettings"
      == nixSettings."nix.serverSettings"
      && profile."[nix]" == nixSettings."[nix]"
      && profile."lintRunner.tools" ? statix
      && profile."lintRunner.tools" ? shellcheck;
    profilePreservesMergedColourRules =
      builtins.length profile."editor.tokenColorCustomizations".textMateRules
      > builtins.length javascript."editor.tokenColorCustomizations".textMateRules;
    nixServerSettingsRemainObjects =
      nixSettings."nix.serverSettings"
      == {
        nixd.formatting.command = ["alejandra" "-q" "-"];
      };
    lintToolsRemainObjects =
      nixSettings."lintRunner.tools".statix.command
      == "statix"
      && nixSettings."lintRunner.tools".statix.parser.flags == "gm";
    languageOverridesRemainObjects =
      builtins.isAttrs nixSettings."[nix]"
      && nixSettings."[nix]"."editor.defaultFormatter" == "jnoortheen.nix-ide"
      && !(nixSettings ? "[nix].editor.defaultFormatter");
    javascriptRulesRemainInsideObject = javascript."editor.tokenColorCustomizations" ? textMateRules;
    pythonRulesRemainInsideObject = python."editor.tokenColorCustomizations" ? textMateRules;
    colourRulesMergeAcrossEntries = let
      merged = evaluate (mkMerge [javascript python]);
    in
      merged."editor.tokenColorCustomizations".textMateRules
      == javascript."editor.tokenColorCustomizations".textMateRules
      ++ python."editor.tokenColorCustomizations".textMateRules;
    explicitObjectSettingPreserved =
      flatten {"extension.object".nested.value = true;}
      == {
        "extension.object".nested.value = true;
      };
    nestedLanguageSettingsFlattened =
      flatten {"[nix]".editor.formatOnSave = true;}
      == {
        "[nix]"."editor.formatOnSave" = true;
      };
    emptySettingsRemainEmpty = flatten {} == {};
    emptySettingObjectPreserved = flatten {"extension.object" = {};} == {"extension.object" = {};};
    deeplyNestedScalarSetting =
      flatten {"rust-analyzer".diagnostics.enable = true;}
      == {
        "rust-analyzer.diagnostics.enable" = true;
      };
    legacyPrefixSupported =
      flattenVSCodeSetting "extension" {enabled = true;}
      == {
        "extension.enabled" = true;
      };
    aliasesMergeAfterFlattening =
      normalizeSettings {
        userSettings."editor.formatOnSave" = false;
        settings.editor.formatOnSave = true;
      }
      == {"editor.formatOnSave" = true;};
    moduleMergePreserved =
      evaluate (flatten (mkMerge [
        {editor.formatOnSave = false;}
        (mkIf true {editor.formatOnSave = mkForce true;})
      ]))
      == {"editor.formatOnSave" = true;};
    namespacePriorityPreserved =
      evaluate (flatten (mkForce {editor.formatOnSave = true;}))
      == {
        "editor.formatOnSave" = true;
      };
  };
in {
  total = builtins.length (builtins.attrNames checks);
  failures = builtins.filter (name: !checks.${name}) (builtins.attrNames checks);
}
