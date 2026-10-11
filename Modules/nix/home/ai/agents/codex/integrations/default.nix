{
  lix,
  cfg,
  ...
}: let
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.options.construction) mkOption mkTrue;
  inherit (lix.types.combinators) attrsOf;
  inherit (lix.types.primitives) anything;
in {
  options.mcp = {
    enable = mkTrue ''
      Merge the shared `programs.mcp.servers` into Codex's `mcp_servers`
      (`programs.codex.enableMcpIntegration`). Servers in `mcp.servers` take precedence.
    '';

    servers = mkOption {
      type = attrsOf anything;
      default = {};
      description = ''
        Codex-only MCP servers by name, written to `mcp_servers` in config.toml,
        for example `docs = {command = "docs-server"; args = ["--port" "4000"];}`.
        Servers every tool should share belong in `programs.mcp.servers`.
        [WARNING] Do not put tokens in `env`; use `env_vars` or
        `bearer_token_env_var` so secrets stay out of the Nix store.
      '';
    };
  };

  # Skip the key when empty so no empty [mcp_servers] table is emitted.
  settings = optionalAttrs (cfg.mcp.servers != {}) {mcp_servers = cfg.mcp.servers;};

  programs.enableMcpIntegration = cfg.mcp.enable;
}
