{
  flake,
  exportFixture ? false,
}: let
  inherit (flake.lib) lix;
  inherit (lix.lists.predicates) all any;
  inherit (lix.lists.selection) filter;
  inherit (lix.strings.predicates) hasInfix;

  pkgs = import flake.inputs.nixPackages {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  home = extra:
    (flake.inputs.nixHomeManager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit lix;
        inputs.hermes-agent = flake.inputs.hermes;
        user.packages.ai-agent = ["hermes"];
        user.applications.allowed = ["hermes"];
      };
      modules = [
        flake.inputs.hermes.homeManagerModules.default
        ../../../Modules/nix/home/ai/agents/hermes
        ({lib, ...}: {
          options._.outputs = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = {};
          };
          config = {
            home = {
              username = "hermes-test";
              homeDirectory = "/tmp/hermes-module-check";
              stateVersion = "26.05";
            };
            _.resolved.ai.agents.hermes-agent.explicit = extra;
          };
        })
      ];
    }).config;
  failures = evaluated: map (entry: entry.message) (filter (entry: !entry.assertion) evaluated.assertions);
  rejects = extra: !(builtins.tryEval (builtins.deepSeq (home extra).assertions true)).success;
  baseline = home {};
  declaration = {
    services = {
      gateway.enable = true;
      extraDependencyGroups = ["messaging"];
      environmentFiles = ["/run/secrets/main.env"];
      settings.example.preserved = true;
    };
    profiles = {
      intake = {
        description = "Collect requirements and route work.";
        bot = {
          enable = true;
          title = "Reception";
        };
        settings.model = {
          provider = "ollama";
          default = "qwen3:4b-instruct";
          base_url = "http://127.0.0.1:11434/v1";
        };
        environmentFiles = ["/run/secrets/intake.env"];
      };
      planner = {
        settings.model = {
          provider = "custom";
          default = "planner-model";
        };
      };
      reviewer = {
        settings.model = {
          provider = "custom";
          default = "review-model";
        };
      };
      parked.enable = false;
    };
    gateway.routes = [
      {
        platform = "telegram";
        profile = "intake";
        chat_id = "123";
      }
    ];
    swarm = {
      enable = true;
      profiles = ["planner" "reviewer"];
      orchestrator = "planner";
      defaultAssignee = "planner";
      decomposition = {
        enable = true;
        model = {
          provider = "custom";
          model = "planner-model";
        };
      };
    };
  };
  team = home declaration;
  activation = team.home.activation.hermesProfiles;
  settings = team.services.hermes-agent.settings;
  withChange = change: lix.attrsets.aggregation.recursiveUpdate declaration change;
  bots = import ../../../Modules/nix/home/ai/agents/hermes/bots {
    inherit lix;
    cfg = team._.resolved.ai.agents.hermes-agent.explicit;
    common.effectivePackage = _service: "/test/hermes";
    config.services.hermes-agent.hermesHome = "/test/home";
    pkgs.writeShellScriptBin = name: text: {inherit name text;};
  };
in
  if exportFixture
  then {
    settings = team.services.hermes-agent.settings;
    defaultSettings =
      (home {
        profiles.worker = {};
        swarm.enable = true;
      }).services.hermes-agent.settings;
    profiles = lix.attrsets.transformation.mapAttrs (name: profile: {
      inherit (profile) settings;
      metadata = bots.metadata name profile;
    }) (lix.attrsets.transformation.filterAttrs (_name: profile: profile.enable) team._.resolved.ai.agents.hermes-agent.explicit.profiles);
  }
  else {
    baseline =
      baseline.services.hermes-agent.gateway.enable
      && baseline.services.hermes-agent.settings == {}
      && !(baseline.home.activation ? hermesProfiles);
    team = failures team == [];
    routes =
      settings.multiplex_profiles
      && settings.profile_routes
      == [
        {
          platform = "telegram";
          profile = "intake";
          chat_id = "123";
        }
      ];
    defaultAssignee =
      (home {
        profiles.worker = {};
        swarm.enable = true;
      }).services.hermes-agent.settings.kanban.default_assignee
      == "default";
    dispatch =
      settings.kanban.dispatch_profiles
      == ["planner" "reviewer"]
      && settings.kanban.orchestrator_profile == "planner"
      && settings.kanban.default_assignee == "planner"
      && settings.kanban.max_in_progress == 1
      && settings.kanban.max_in_progress_per_profile == 1
      && settings.kanban.auto_decompose
      && settings.auxiliary.kanban_decomposer.model == "planner-model";
    rawSettings = settings.example.preserved;
    profileActivation =
      activation.after
      == ["hermesAgentSetup"]
      && activation.before == ["reloadSystemd"]
      && all (name: hasInfix "/profiles/${name}/config.yaml" activation.data) ["intake" "planner" "reviewer"]
      && !(hasInfix "/profiles/parked/" activation.data);
    credentialIsolation =
      hasInfix "/run/secrets/intake.env" activation.data
      && !(hasInfix "/run/secrets/main.env" activation.data);
    botLauncher = any (package:
      package.name
      == "hermes-bot-intake"
      && hasInfix "--profile" package.text
      && hasInfix "intake" package.text
      && hasInfix ''chat -c "Bot Chat" --create-if-missing "$@"'' package.text)
    bots.outputs.home.packages;
    gatewayReload =
      all (trigger: trigger.drvPath != "") team.systemd.user.services.hermes-agent.Unit.X-Restart-Triggers
      && team.systemd.user.services.hermes-agent.Unit.X-Restart-Triggers != [];
    activationDerivation = team.home.activationPackage.drvPath != "";
    customHome =
      hasInfix "/tmp/custom-hermes/profiles/intake/config.yaml"
      (home (withChange {
        services.hermesHome = "/tmp/custom-hermes";
      })).home.activation.hermesProfiles.data;
    botMetadata = bots.metadata "intake" declaration.profiles.intake == {ui_meta.hermes-bots.title = "Reception";};
    disabledBot = bots.metadata "plain" {bot.enable = false;} == {ui_meta.hermes-bots = null;};
    defaultRoster =
      (home {
        profiles.worker = {};
        swarm.enable = true;
      }).services.hermes-agent.settings.kanban.dispatch_profiles
      == ["default" "worker"];
    pausedDispatch =
      failures (home (withChange {swarm.profiles = [];}))
      == []
      && (home (withChange {swarm.profiles = [];})).services.hermes-agent.settings.kanban.dispatch_profiles == [];
    unknownRoute = rejects (withChange {gateway.routes = [{profile = "missing";}];});
    disabledRoute = rejects (withChange {gateway.routes = [{profile = "parked";}];});
    emptySender = rejects (withChange {
      gateway.routes = [
        {
          profile = "intake";
          user_id = " ";
        }
      ];
    });
    missingMultiplexer = rejects (withChange {gateway.multiplex = false;});
    invalidWorker = rejects (withChange {swarm.profiles = ["missing"];});
    excludedAssignee = rejects (withChange {swarm.profiles = ["reviewer"];});
    invalidConcurrency = rejects (withChange {swarm.concurrency.total = 0;});
    missingGateway = rejects (withChange {services.gateway.enable = false;});
    invalidProfileName = rejects (withChange {profiles."../escape" = {};});
    reservedDefault = rejects (withChange {profiles.default = {};});
    implicitWorkspace = rejects (withChange {profiles.intake.documents."AGENTS.md" = "Public instructions";});
  }
