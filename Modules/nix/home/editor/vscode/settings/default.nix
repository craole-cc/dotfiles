{lix, ...} @ args: let
  inherit (lix.attrsets.aggregation) recursiveUpdate;
  inherit (lix.lists.aggregation) foldl';
  inherit (lix.options.construction) mkTrue mkFalse;
  inherit (lix.attrsets.construction) listToAttrs;

  load = path:
    import path (args
      // {
        inherit (lix.modules.construction) mkDefault mkMerge;
        inherit (lix.lists.transformation) flatten;
        inherit (lix.applications.editors) mkVSCodeFeature mkVSCodeSubFeature;
      });

  entries = map load [
    ./ai.nix
    ./appearance.nix
    ./decorations.nix
    ./infrastructure.nix
    ./markup.nix
    ./nix.nix
    ./productivity.nix
    ./scripting.nix
    ./systems.nix
    ./vcs.nix
    ./web.nix
  ];

  coreSettings = map load [
    ./global.nix
    ./editor.nix
    ./files.nix
    ./terminal.nix
  ];

  mkOption = entry:
    with entry;
      if default
      then mkTrue description
      else mkFalse description;
in {
  userSettings = foldl' recursiveUpdate {} (map (entry: entry.userSettings) coreSettings);
  features = listToAttrs (
    map (entry: {
      inherit (entry) name;
      value = entry.feature;
    })
    entries
  );
  options = listToAttrs (
    map (entry: {
      inherit (entry) name;
      value = mkOption entry;
    })
    entries
  );
}
