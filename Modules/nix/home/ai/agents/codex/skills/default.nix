{
  lix,
  cfg,
  ...
}: let
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.combinators) attrsOf either;
  inherit (lix.types.primitives) lines path;
in {
  options.skills = mkOption {
    type = either path (attrsOf (either lines path));
    default = {
      nix-style = ''
        ---
        name: nix-style
        description: House style for Nix modules and expressions. Use whenever writing or editing .nix files.
        ---

        # Nix style

        - Use descriptive variable names, never single-letter ones, including lambda arguments.
        - Write functions with positional arguments, not a single-attribute attrset such as `{user}:`.
        - Group related module options under a namespace (`approval.policy`, `approval.reviewer`) rather than flat camelCase names.
        - Give every option a real type, a default and a description. Do not use hidden baseline attrsets or on/off "defaults" switches.
        - Merge settings layers key by key with module-system priorities (`mkOverride`, `mkMerge`) instead of replacing a whole attrset.
      '';

      nix-inspect = ''
        ---
        name: nix-inspect
        description: Inspect evaluated Nix and Home Manager configuration without building or deploying. Use when debugging option values, merges, or generated files.
        ---

        # Inspecting Nix configuration

        - Print an option in `nix repl` with `:p config.<path>`. Derivations print as `«derivation ...»`, which is not valid syntax to paste back.
        - To read a generated file, use `builtins.readFile <attribute>.source`. The store path may not exist until it is built.
        - Prefer `nix eval` for one-off checks. Never run switch, boot or deploy commands; ask the user to.
      '';

      commit-messages = ''
        ---
        name: commit-messages
        description: Conventions for git commit messages. Use when creating or amending commits.
        ---

        # Commit messages

        - Subject in the imperative mood, at most 72 characters, no trailing period.
        - Body explains why the change was made, not what the diff shows.
        - One logical change per commit.
        - Never commit secrets, tokens or generated credentials.
      '';

      plan-first = ''
        ---
        name: plan-first
        description: Agree a plan before editing files. Use for any change that touches more than one file or has more than one reasonable approach.
        ---

        # Plan first

        1. Restate the goal in one or two sentences and name anything ambiguous.
        2. List the files you expect to change and why, and say what you will not touch.
        3. Describe the approach, the main edge cases, and how you will check the result (tests, a build, a command to run).
        4. Stop and wait for approval before changing any file.
        5. After approval, follow the plan. If you must deviate, say so and why before continuing.
      '';

      writing-style = ''
        ---
        name: writing-style
        description: Voice and punctuation for prose, READMEs, docs, comments and commit messages. Use whenever writing text for humans.
        ---

        # Writing style

        - Casual but technically credible. Write like a person explaining something to a colleague.
        - Prefer colons, semicolons and commas to em dashes.
        - Never start a sentence with "But".
        - Cut throat-clearing openers ("it's worth noting that"), stacked passive voice and filler transitions.
        - If a grammar linter such as Harper flags a comment or doc line, rewrite it toward cleaner wording instead of adding a dictionary exception.
      '';
    };
    description = ''
      Skills by name (`programs.codex.skills`), as inline content or a path to a
      skill directory. Add your own as extra names and they merge with these.
    '';
  };

  programs = {inherit (cfg) skills;};
}
