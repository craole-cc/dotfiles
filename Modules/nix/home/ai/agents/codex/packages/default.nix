{
  lix,
  inputs,
  pkgs,
  ...
} @ args: let
  inherit (lix.attrsets.aggregation) recursiveUpdate;
  inherit (lix.lists.aggregation) foldl';
  inherit (lix.sources.packages) pkgsFrom;

  tools = pkgsFrom {
    inherit inputs pkgs;
    sources = {
      codex = "llm-agents";
      chatgpt = "llm-agents";
    };
  };
in
  foldl' recursiveUpdate {} (
    map (file: import file (args // {inherit tools;})) [./cli ./app]
  )
