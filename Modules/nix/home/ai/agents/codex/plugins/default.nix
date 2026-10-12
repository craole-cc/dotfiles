{
  lix,
  pkgs,
  inputs,
  cfg,
  ...
}: let
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.combinators) attrsOf either listOf;
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.types.primitives) package path str;

  openai = let
    source =
      (inputs.codex-plugins or {
        }).outPath or (pkgs.fetchFromGitHub {
        owner = "openai";
        repo = "plugins";
        rev = "0722921d5542fc593105c27bd52630babd8b8c2a";
        hash = "sha256-0HXOrcWKpNexof5Y7iDOy7wixwvCjF1FoN1M95P+n74=";
      });
    target = name: let
      path = concat {
        root = source;
        stem = ["plugins" name];
      };
    in
      pkgs.runCommandLocal name {} ''
        cp -r --no-preserve=mode ${path} $out
      '';
  in {inherit source target;};
in {
  options = {
    curated.plugins = mkOption {
      type = listOf str;
      default = ["github"];
      description = ''
        Plugins to install from OpenAI's curated marketplace, by folder name
        under `plugins/` in github.com/openai/plugins. Setting this replaces the
        default list, so include `github` if you still want it.
      '';
    };

    plugins = mkOption {
      type = listOf (either package path);
      default = [];
      description = ''
        Extra packaged plugins: a path or a fetcher output (`programs.codex.plugins`).
        A derivation's name must match the plugin's name in its manifest.
        They are added to the ones from `curated`.
      '';
    };

    marketplaces = mkOption {
      type = attrsOf (either package path);
      default = {};
      description = ''
        Extra plugin marketplaces by name: a path or a fetcher output
        (`programs.codex.marketplaces`). They are added to the pinned
        `openai-curated` marketplace; a name that matches replaces it.
      '';
    };
  };

  program = {
    plugins = (map openai.target cfg.curated.plugins) ++ cfg.plugins;
    marketplaces = {openai = openai.source;} // cfg.marketplaces;
  };
}
