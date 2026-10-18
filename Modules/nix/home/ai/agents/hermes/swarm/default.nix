{
  cfg,
  config,
  lix,
  ...
}: let
  inherit (lix.attrsets.access) attrNames;
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.attrsets.transformation) filterAttrs;
  inherit (lix.lists.predicates) all elem;
  inherit (lix.lists.selection) filter;
  inherit (lix.options.construction) mkFalse mkOption;
  inherit (lix.types.combinators) attrsOf listOf nullOr;
  inherit (lix.types.primitives) anything int str;

  active = filterAttrs (_name: profile: profile.enable) cfg.profiles;
  known = name: name == "default" || active ? ${name};
  assignee = description:
    mkOption {
      type = nullOr str;
      default = null;
      inherit description;
    };
  limit = description:
    mkOption {
      type = int;
      default = 1;
      inherit description;
    };
in {
  options.swarm = {
    enable = mkFalse "Enable Hermes Kanban task dispatch for the declared team.";
    profiles = mkOption {
      type = listOf str;
      default = ["default"] ++ attrNames active;
      description = "Profiles the dispatcher may assign work to. An empty list explicitly admits no workers.";
    };
    orchestrator = assignee "Profile owning orchestration tasks. Null uses the default profile.";
    defaultAssignee = assignee "Assignee for unassigned tasks and unmatched decomposition choices. Null explicitly selects the default profile.";
    concurrency = {
      total = limit "Maximum concurrent Kanban workers across the host.";
      perProfile = limit "Maximum concurrent Kanban workers for one profile.";
    };
    decomposition = {
      enable = mkFalse "Automatically decompose triage tasks. Hermes's planner sees all installed profiles, including profiles outside swarm.profiles.";
      model = mkOption {
        type = attrsOf anything;
        default = {};
        description = "Public auxiliary.kanban_decomposer settings, such as provider and model. Empty uses the main model.";
      };
    };
  };

  settings = optionalAttrs cfg.swarm.enable ({
      kanban = {
        dispatch_in_gateway = true;
        dispatch_profiles = cfg.swarm.profiles;
        max_in_progress = cfg.swarm.concurrency.total;
        max_in_progress_per_profile = cfg.swarm.concurrency.perProfile;
        auto_decompose = cfg.swarm.decomposition.enable;
        orchestrator_profile =
          if cfg.swarm.orchestrator == null
          then "default"
          else cfg.swarm.orchestrator;
        default_assignee =
          if cfg.swarm.defaultAssignee == null
          then "default"
          else cfg.swarm.defaultAssignee;
      };
    }
    // optionalAttrs (cfg.swarm.decomposition.model != {}) {
      auxiliary.kanban_decomposer = cfg.swarm.decomposition.model;
    });

  outputs.assertions = [
    {
      assertion = !cfg.swarm.enable || (cfg.gateway.multiplex && config.services.hermes-agent.gateway.enable);
      message = "Hermes swarm dispatch requires gateway.multiplex and an enabled gateway service.";
    }
    {
      assertion = !cfg.swarm.enable || all known (cfg.swarm.profiles ++ (filter (name: name != null) [cfg.swarm.orchestrator cfg.swarm.defaultAssignee]));
      message = "Hermes swarm workers and assignees must reference default or enabled declared profiles.";
    }
    {
      assertion =
        !cfg.swarm.enable
        || cfg.swarm.profiles == []
        || all (name: elem name cfg.swarm.profiles) [
          (
            if cfg.swarm.orchestrator == null
            then "default"
            else cfg.swarm.orchestrator
          )
          (
            if cfg.swarm.defaultAssignee == null
            then "default"
            else cfg.swarm.defaultAssignee
          )
        ];
      message = "Hermes swarm orchestration and fallback assignees must be included in swarm.profiles, or dispatch must be explicitly paused with an empty list.";
    }
    {
      assertion = cfg.swarm.concurrency.total > 0 && cfg.swarm.concurrency.perProfile > 0;
      message = "Hermes swarm concurrency limits must be positive integers.";
    }
  ];
}
