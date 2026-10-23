{lix, ...} @ args: let
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.options.construction) mkTrue mkFalse;
  inherit (lix.attrsets.construction) genAttrs listToAttrs;

  load = path:
    import path (args
      // {
        inherit (lix.modules.construction) mkDefault mkMerge;
        inherit (lix.lists.transformation) flatten;
        inherit (lix.applications.editors) mkVSCodeFeature mkVSCodeSubFeature;
      });

  settings = map load [
    ./global.nix
    ./editor.nix
    ./files.nix
    ./linting.nix
    ./remote.nix
    ./terminal.nix
  ];
  features = map load [
    ./ai.nix
    # ./appearance.nix
    # ./decorations.nix
    # ./infrastructure.nix
    # ./markup.nix
    # ./nix.nix
    # ./productivity.nix
    # ./scripting.nix
    # ./systems.nix
    # ./vcs.nix
    # ./web.nix
  ];
in
  {
    userSettings = mergeSafe (
      map (entry: entry.userSettings) settings
    );
  }
  // genAttrs ["features" "options"] (type:
    listToAttrs (
      map (entry: {
        inherit (entry) name;
        value =
          if type == "features"
          then entry.feature
          else
            (with entry;
              if default
              then mkTrue description
              else mkFalse description);
      })
      features
    ))
