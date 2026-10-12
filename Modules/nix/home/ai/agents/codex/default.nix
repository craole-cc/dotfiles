{
  config,
  lix,
  user,
  inputs,
  pkgs,
  ...
}: let
  dom = "ai";
  sub = "agents";
  mod = "codex";

  inherit (lix.attrsets.aggregation) recursiveUpdate recursiveUpdateUntil;
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.filesystem.access) readFile;
  inherit (lix.lists.aggregation) foldl';
  inherit (lix.lists.predicates) isIn;
  inherit (lix.lists.transformation) filter;
  inherit (lix.modules.construction) mkConfig mkContext mkIf mkMerge mkLayer;
  inherit (lix.options.construction) mkEnable mkOption mkTrue;
  inherit (lix.sources.packages) pkgsFrom;
  inherit (lix.types.combinators) attrsOf either nullOr;
  inherit (lix.types.predicates) isAttrs;
  inherit (lix.types.primitives) anything lines package path;

  context = mkContext {inherit config dom sub mod;};
  inherit (context) cfg;

  tools = pkgsFrom {
    inherit inputs pkgs;
    sources = {
      ${mod} = "llm-agents";
      chatgpt = "llm-agents";
    };
  };
  meta = tools.${mod};

  # Merge plain namespaces key by key, but treat module-system values
  # (option declarations, mkIf, mkMerge, mkOverride, ...) as atomic: right wins.
  merge = recursiveUpdateUntil (
    _path: left: right:
      !(isAttrs left && isAttrs right)
      || left ? _type
      || right ? _type
  );

  # Each part returns { options, settings, program, outputs }; any may be absent.
  parts =
    map
    (file: import file {inherit lix pkgs cfg inputs tools;})
    [
      ./hooks
      ./integrations
      ./plugins
      ./profiles
      ./rules
      ./settings
      ./packages
      ./skills
    ];

  collect = field: foldl' merge {} (map (part: part.${field} or {}) parts);

  settings = let
    typed = collect "settings";
    custom =
      optionalAttrs (cfg.settings != null)
      (fromTOML (readFile cfg.settings));
  in {
    inherit typed custom;
    generated = foldl' recursiveUpdate {} [typed custom cfg.config];
  };

  options = merge (collect "options") {
    enable = mkEnable {
      inherit context;
      condition = isIn [mod] (let
        domain = user.applications.${dom} or {};
      in
        (user.applications.allowed or [])
        ++ map (module: domain.${module}) (
          filter (module: domain ? ${module})
          ["primary" "secondary" "tertiary"]
        ));
    };

    package = mkOption {
      default = meta.package;
      description = ''
        Taken from the flake inputs rather than nixpkgs, so it tracks upstream Codex releases more closely.
      '';
      type = package;
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
      default = settings.generated;
      description = ''
        Preview of the settings this module contributes to `programs.codex.settings`,
        layered typed options < prewritten file < `config`.
        Settings that other modules add to `programs.codex.settings` are not included.
      '';
    };
  };

  programs = merge (collect "program") {
    enable = true;
    inherit (cfg) package;
    mutableSettings = cfg.mutable;
    context = mkIf (cfg.context != null) cfg.context;
    settings = mkMerge (with settings; [
      (mkLayer 900 typed)
      (mkLayer 800 custom)
      cfg.config
    ]);
  };
in
  mkConfig {
    inherit context options;
    outputs = mkMerge [
      {programs.${mod} = programs;}
      (collect "outputs")
    ];
  }
