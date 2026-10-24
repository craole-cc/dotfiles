{
  mkGroup,
  mkEntry,
  ...
} @ args: let
  productivity = import ./entries/productivity.nix args;
in
  mkGroup {
    name = "spelling-prose";
    description = "Spelling & Prose";
    default = true;
    features =
      [
        (mkEntry {
          userSettings = builtins.fromJSON ''
            {
              "harper.dialect": "British",
              "harper.workspaceDictPath": ".harper-dictionary.txt",
              "harper.excludePatterns": [],
              "harper.linters.Dashes": false,
              "harper.linters.NumericRangeEnDash": false,
              "harper.linters.OxfordComma": false,
              "harper.linters.SentenceCapitalization": false,
              "typos.diagnosticSeverity": "Hint"
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
        productivity.entries.spelling
      ];
  }
