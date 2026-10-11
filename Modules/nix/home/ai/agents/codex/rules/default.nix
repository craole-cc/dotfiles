{
  lix,
  cfg,
  ...
}: let
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.combinators) attrsOf either;
  inherit (lix.types.primitives) lines path;
in {
  options.rules = mkOption {
    type = attrsOf (either lines path);
    default.common = ''
      #~@ Read-only inspection never needs a prompt.
      prefix_rule(pattern = ["git", "status"], decision = "allow")
      prefix_rule(pattern = ["git", "diff"], decision = "allow")
      prefix_rule(pattern = ["git", "log"], decision = "allow")
      prefix_rule(pattern = ["git", "show"], decision = "allow")
      prefix_rule(pattern = ["nix", "eval"], decision = "allow")
      prefix_rule(pattern = ["nix", "flake", "show"], decision = "allow")

      #~@ History-rewriting and publishing stay with a human.
      prefix_rule(pattern = ["git", "push"], decision = "prompt")
      prefix_rule(pattern = ["git", "reset", "--hard"], decision = "prompt")
    '';
    description = ''
      Command prefix rules, one file per name under `~/.codex/rules/`
      (`programs.codex.rules`). Add your own as extra names, such as
      `rules.work`, and they merge with the common set.
    '';
  };

  programs = {inherit (cfg) rules;};
}
