{
  config,
  inputs,
  system,
  lix,
  user,
  pkgs,
  ...
}: let
  dom = "ai";
  sub = "agents";
  mod = "codex";

  inherit (lix.attrsets.aggregation) recursiveUpdate;
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.attrsets.transformation) mapAttrsRecursive;
  inherit (lix.filesystem.access) readFile;
  inherit (lix.lists.aggregation) foldl';
  inherit (lix.lists.predicates) isIn;
  inherit (lix.lists.transformation) filter;
  inherit (lix.modules.construction) mkConfig mkContext mkIf mkMerge mkOverride;
  inherit (lix.options.construction) mkEnable mkOption mkPackageOption mkTrue;
  inherit (lix.types.combinators) attrsOf either nullOr;
  inherit (lix.types.primitives) anything lines path;

  context = mkContext {inherit config dom sub mod;};
  inherit (context) cfg;

  # Give every leaf the same priority, so a layer still merges key by key.
  layer = priority: attributes:
    mapAttrsRecursive (_path: value: mkOverride priority value) attributes;

  # Each part returns { options, settings, programs }; any of them may be absent.
  parts =
    map
    (file: import file {inherit lix pkgs cfg;})
    [
      ./settings
      ./skills
      ./plugins
      ./hooks
      ./rules
      ./profiles
      ./models
    ];

  gather = field:
    foldl' recursiveUpdate {} (map (part: part.${field} or {}) parts);

  typed = gather "settings";
  prewritten =
    optionalAttrs (cfg.settings != null)
    (fromTOML (readFile cfg.settings));
  generated = foldl' recursiveUpdate {} [typed prewritten cfg.config];
in
  mkConfig {
    inherit context;

    options =
      gather "options"
      // {
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

        context = mkOption {
          type = nullOr (either lines path);
          default = null;
          description = ''
            Global instructions, written to `~/.codex/AGENTS.md` (`programs.codex.context`).
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
          default = generated;
          description = ''
            Preview of the settings this module contributes to `programs.codex.settings`,
            layered typed options < prewritten file < `config`.
            Settings that other modules add to `programs.codex.settings` are not included.
          '';
        };
      };

    outputs.programs.codex =
      gather "programs"
      // {
        enable = true;
        inherit (cfg) package;
        mutableSettings = cfg.mutable;
        context = mkIf (cfg.context != null) cfg.context;
        settings = mkMerge [
          (layer 900 typed)
          (layer 800 prewritten)
          cfg.config
        ];
      };
  }
