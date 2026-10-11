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
  inherit (lix.attrsets.transformation) filterAttrs mapAttrsRecursive;
  inherit (lix.filesystem.access) readFile;
  inherit (lix.lists.aggregation) foldl';
  inherit (lix.lists.predicates) isIn;
  inherit (lix.lists.transformation) filter;
  inherit (lix.modules.construction) mkConfig mkContext mkIf mkMerge mkOverride;
  inherit (lix.options.construction) mkEnable mkEnum mkFalse mkOption mkPackageOption mkTrue;
  inherit (lix.types.combinators) attrsOf either listOf nullOr;
  inherit (lix.types.primitives) anything lines path str;

  context = mkContext {inherit config dom sub mod;};
  inherit (context) cfg;

  withoutNulls = filterAttrs (_: value: value != null);

  # Give every leaf the same priority, so a layer still merges key by key.
  layer = priority: attributes:
    mapAttrsRecursive (_path: value: mkOverride priority value) attributes;

  settings = let
    typed =
      recursiveUpdate (withoutNulls {
        model = cfg.model.main;
        review_model = cfg.model.review;
        approval_policy = cfg.approval.policy;
        approvals_reviewer = cfg.approval.reviewer;
        sandbox_mode = cfg.sandbox.mode;
        check_for_update_on_startup = cfg.update.check;
        tui = withoutNulls {
          notifications = cfg.tui.notifications;
          notification_condition = cfg.tui.condition;
        };
      }) (
        optionalAttrs (cfg.mcp.servers != {})
        {mcp_servers = cfg.mcp.servers;}
      );
    prewritten =
      optionalAttrs (cfg.settings != null)
      (fromTOML (readFile cfg.settings));
    generated = foldl' recursiveUpdate {} [typed prewritten cfg.config];
  in {inherit typed prewritten generated;};
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

      package =
        mkPackageOption
        inputs.llm-agents.packages.${system}
        mod {
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
        policy = mkEnum {
          input = ["on-request" "on-failure" "never"];
          default = "on-request";
          description = ''
            When Codex pauses to ask before acting (`approval_policy`).
            Auto-review needs an interactive policy such as on-request; with never there is nothing to review.
          '';
        };
        reviewer = mkEnum {
          input = ["user" "auto_review"];
          default = "auto_review";
          description = ''
            Who handles eligible approval prompts (`approvals_reviewer`):
            the user (you), or the separate auto-review agent.
          '';
        };
      };

      sandbox = {
        mode = mkEnum {
          input = ["read-only" "workspace-write" "danger-full-access"];
          default = "workspace-write";
          description = ''What Codex may touch on disk (`sandbox_mode`).'';
        };
      };

      update = {
        check = mkFalse ''
          Whether Codex checks for updates on startup (`check_for_update_on_startup`).
          Off by default because Nix pins the package.
        '';
      };

      tui = {
        notifications = mkOption {
          type = nullOr (listOf str);
          default = ["agent-turn-complete" "approval-requested"];
          description = ''
            Events that trigger a terminal notification.
          '';
        };
        condition = mkEnum {
          input = ["unfocused" "always"];
          default = "unfocused";
          description = ''
            When notifications fire (`tui.notification_condition`).
          '';
        };
      };

      rules = mkOption {
        type = attrsOf anything;
        default.common = ''
          # Read-only inspection never needs a prompt.
          prefix_rule(pattern = ["git", "status"], decision = "allow")
          prefix_rule(pattern = ["git", "diff"], decision = "allow")
          prefix_rule(pattern = ["git", "log"], decision = "allow")
          prefix_rule(pattern = ["git", "show"], decision = "allow")
          prefix_rule(pattern = ["nix", "eval"], decision = "allow")
          prefix_rule(pattern = ["nix", "flake", "show"], decision = "allow")

          # History-rewriting and publishing stay with a human.
          prefix_rule(pattern = ["git", "push"], decision = "prompt")
          prefix_rule(pattern = ["git", "reset", "--hard"], decision = "prompt")
        '';
        description = ''
          Command prefix rules, one file per name under `~/.codex/rules/`.
          Add your own as extra names, such as
          `rules.work`, and they merge with the common set.
        '';
      };

      skills = mkOption {
        type = attrsOf anything;
        default = {};
        description = ''
          Custom skills by name, such as `skills.data-analysis = ./skills/data-analysis;`.
        '';
      };

      plugins = mkOption {
        default = [];
        description = ''
          Plugin packages or fetcher outputs.
        '';
        type = listOf anything;
      };

      marketplaces = mkOption {
        default = {};
        description = ''
          Custom plugin marketplaces.
        '';
        type = attrsOf anything;
      };

      hooks = mkOption {
        default = {};
        description = ''
          Lifecycle hooks.
        '';
        type = attrsOf anything;
      };

      profiles = mkOption {
        default = {};
        description = ''
          Config profiles.
        '';
        type = attrsOf anything;
      };

      mcp = {
        enable = mkTrue ''
          Merge the shared `programs.mcp.servers` into Codex's `mcp_servers`.
          Servers in `mcp.servers` take precedence.
        '';
        servers = mkOption {
          default = {};
          description = ''
            Codex-only MCP servers by name, written to `mcp_servers` in config.toml,
            for example `docs = {command = "docs-server"; args = ["--port" "4000"];}`.
            Servers every tool should share belong in `programs.mcp.servers`.
            [WARNING] Do not put tokens in `env`; use `env_vars` or
            `bearer_token_env_var` so secrets stay out of the Nix store.
          '';
          type = attrsOf anything;
        };
      };

      context = mkOption {
        type = nullOr (either lines path);
        default = null;
        description = ''
          Global instructions.
        '';
      };

      mutable = mkTrue ''
        Merge declared settings into a writable config.toml at activation instead of
        symlinking a read-only file, so settings Codex writes itself survive
        (`programs.codex.mutableSettings`).
      '';

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
        default = settings.generated;
        description = ''
          Preview of the settings this module contributes to `programs.codex.settings`,
          layered typed options < prewritten file < `config`.
          Settings that other modules add to `programs.codex.settings` are not included.
        '';
      };
    };

    outputs = {
      programs = {
        codex = {
          enable = true;
          inherit (cfg) package rules skills hooks plugins profiles marketplaces;
          enableMcpIntegration = cfg.mcp.enable;
          mutableSettings = cfg.mutable;
          context = mkIf (cfg.context != null) cfg.context;
          settings = with settings;
            mkMerge [
              (layer 900 typed)
              (layer 800 prewritten)
              cfg.config
            ];
        };
        mcp = {};
      };
    };
  }
