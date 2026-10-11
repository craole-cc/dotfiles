{
  lix,
  cfg,
  ...
}: let
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.combinators) attrsOf;
  inherit (lix.context.emptiness) withoutNulls;
  inherit (lix.types.primitives) anything;
in {
  options.profiles = mkOption {
    type = attrsOf anything;
    default = {
      # Read-only second opinion on a change, using the review model.
      review = withoutNulls {
        model = cfg.model.review;
        model_reasoning_effort = "high";
        approval_policy = "on-request";
        sandbox_mode = "read-only";
      };

      # Hard problems: the review model at maximum reasoning.
      deep = withoutNulls {
        model = cfg.model.review;
        model_reasoning_effort = "xhigh"; # TODO: Check if this is correct or if it should be `max`.
      };

      # Small edits and questions where speed matters more than depth.
      quick = {
        model_reasoning_effort = "low";
      };
    };
    description = ''
      Named config profiles written to `~/.codex/<name>.config.toml`
      (`programs.codex.profiles`), selected with `codex --profile <name>`.
    '';
  };

  programs = {inherit (cfg) profiles;};
}
