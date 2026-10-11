{
  lix,
  cfg,
  ...
}: let
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.combinators) attrsOf either listOf;
  inherit (lix.types.primitives) package path;
in {
  options = {
    plugins = mkOption {
      type = listOf (either package path);
      default = [];
      description = ''
        Packaged plugins: a path or a fetcher output (`programs.codex.plugins`).
        A derivation's name must match the plugin's name in its manifest.
        Plugins from OpenAI's curated directory need no packaging: install them
        with `/plugins` in Codex, and toggle them through
        `config.plugins."<name>@<marketplace>".enabled`.
      '';
    };

    marketplaces = mkOption {
      type = attrsOf (either package path);
      default = {};
      description = ''
        Custom plugin marketplaces by name: a path or a fetcher output
        (`programs.codex.marketplaces`).
      '';
    };
  };

  programs = {inherit (cfg) plugins marketplaces;};
}
