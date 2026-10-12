{lix, ...} @ args: let
  inherit (lix.attrsets.aggregation) recursiveUpdate;
  inherit (lix.lists.aggregation) foldl';
in
  foldl' recursiveUpdate {} (
    map (file: import file args) [./cli ./app]
  )
