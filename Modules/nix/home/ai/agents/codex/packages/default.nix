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
  meta = tools.codex;
in
  foldl' recursiveUpdate {} (
    map (file: import file args) [./cli ./app]
  )
