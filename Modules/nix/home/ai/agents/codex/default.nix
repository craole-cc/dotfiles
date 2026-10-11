{
  config,
  inputs,
  system,
  lix,
  user,
  ...
}: let
  dom = "ai";
  sub = "agents";
  mod = "codex";

  inherit (lix.attrsets.aggregation) recursiveUpdate;
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.attrsets.transformation) filterAttrs;
  inherit (lix.filesystem.access) readFile;
  inherit (lix.lists.predicates) isIn;
  inherit (lix.lists.transformation) filter;
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkEnable mkOption mkPackageOption;
  inherit (lix.types.combinators) attrsOf enum nullOr;
  inherit (lix.types.primitives) anything bool path str;

  context = mkContext {inherit config dom sub mod;};
  inherit (context) cfg;

  withoutNulls = filterAttrs (_: value: value != null);

  # Final config.toml contents: typed options < prewritten file < `config`.
  settings = let
    typed = withoutNulls {
      model = cfg.model.main;
      review_model = cfg.model.review;
      approval_policy = cfg.approval.policy;
      approvals_reviewer = cfg.approval.reviewer;
      sandbox_mode = cfg.sandbox.mode;
    };
    prewritten =
      optionalAttrs (cfg.settings != null)
      (fromTOML (readFile cfg.settings));
  in
    recursiveUpdate (recursiveUpdate typed prewritten) cfg.config;

  # Forwarded to programs.codex under Home Manager's own option names.
  # Null means unset, so Home Manager keeps its default.
  passthrough = withoutNulls {
    mutableSettings = cfg.mutable;
    custom-instructions = cfg.instructions;
    enableMcpIntegration = cfg.mcp;
    inherit (cfg) rules skills hooks plugins profiles;
  };
in
  mkConfig {
    inherit context;

    options = {
      enable = mkEnable {
        inherit context;
        condition = isIn ["codex"] (let
          domain = user.applications.${dom} or {};
        in
          (user.applications.allowed or [])
          ++ map (module: domain.${module}) (
            filter (module: domain ? ${module})
            ["primary" "secondary" "tertiary"]
          ));
      };

      package = mkPackageOption inputs.llm-agents.packages.${system} mod {
        pkgsText = "inputs.llm-agents.packages.<system>";
        extraDescription = ''
          Taken from llm-agents rather than nixpkgs, so it tracks upstream Codex releases more closely.
        '';
      };

      model = {
        main = mkOption {
          type = nullOr str;
          default = "gpt-6-luna";
          description = ''
            Model for normal Codex work (`model`). Null leaves the choice to Codex.
          '';
        };
        review = mkOption {
          type = nullOr str;
          default = "gpt-6.1-sol";
          description = ''
            Model for the `/review` command (`review_model`).
            Does not affect auto-review approval decisions.
          '';
        };
      };

      approval = {
        policy = mkOption {
          type = nullOr (enum ["on-request" "on-failure" "never"]);
          default = "on-request";
          description = ''
            When Codex pauses to ask before acting (`approval_policy`).
            Auto-review needs an interactive policy such as on-request; with never there is nothing to review.
          '';
        };
        reviewer = mkOption {
          type = nullOr (enum ["user" "auto_review"]);
          default = "auto_review";
          description = ''
            Who handles eligible approval prompts (`approvals_reviewer`):
            the user (you), or the separate auto-review agent.
          '';
        };
      };

      sandbox = {
        mode = mkOption {
          type = nullOr (enum ["read-only" "workspace-write" "danger-full-access"]);
          default = "workspace-write";
          description = ''What Codex may touch on disk (`sandbox_mode`).'';
        };
      };

      config = mkOption {
        type = attrsOf anything;
        default = {};
        description = ''
          Extra config.toml settings with no typed option.
          Merged last, so it overrides both the typed options and the prewritten file.
          [WARNING] Do not put credentials here: the generated file lives in the
          world-readable Nix store. Reference them through a provider `env_key`
          or auth command instead.
        '';
      };

      settings = mkOption {
        type = nullOr path;
        default = null;
        description = ''
          A prewritten public config.toml, merged underneath `config` and over the typed options.
          [WARNING] Do not put credentials in it: Nix path inputs are copied into the
          world-readable store. Reference them through a provider `env_key` or auth
          command instead.
        '';
      };

      generated = mkOption {
        type = attrsOf anything;
        readOnly = true;
        default = settings;
        description = ''
          The final merged config.toml contents, for inspection (read-only).
        '';
      };

      mutable = mkOption {
        type = nullOr bool;
        default = null;
        description = ''
          Forwarded to `programs.codex.mutableSettings`. Null keeps Home Manager's default.
        '';
      };

      instructions = mkOption {
        type = nullOr anything;
        default = null;
        description = ''
          Global instructions, forwarded to `programs.codex.custom-instructions`.
        '';
      };

      mcp = mkOption {
        type = nullOr bool;
        default = null;
        description = ''
          Forwarded to `programs.codex.enableMcpIntegration`.
        '';
      };

      rules = mkOption {
        type = nullOr anything;
        default = null;
        description = ''
          Command prefix rules, forwarded to `programs.codex.rules`.
        '';
      };

      skills = mkOption {
        type = nullOr anything;
        default = null;
        description = ''
          Forwarded to `programs.codex.skills`.
        '';
      };

      hooks = mkOption {
        type = nullOr anything;
        default = null;
        description = ''
          Lifecycle hooks, forwarded to `programs.codex.hooks`.
        '';
      };

      plugins = mkOption {
        type = nullOr anything;
        default = null;
        description = ''
          Forwarded to `programs.codex.plugins`.
        '';
      };

      profiles = mkOption {
        type = nullOr anything;
        default = null;
        description = ''
          Config profiles, forwarded to `programs.codex.profiles`.
        '';
      };
    };

    outputs.programs.codex =
      {
        enable = true;
        inherit (cfg) package;
        inherit settings;
      }
      // passthrough;
  }
