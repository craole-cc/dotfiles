{
  config,
  lix,
  inputs,
  pkgs,
  host,
  user,
  paths,
  entryAfter,
  ...
}: let
  inherit (lix.applications.generators) userApplicationConfig;
  inherit (lix.attrsets.construction) genAttrs;
  inherit (lix.modules.construction) mkConfig mkContext mkMerge mkDefault;
  inherit (lix.options.construction) mkEnable mkTrue;
  inherit (lix.lists.construction) optional;
  inherit (lix.schema.fonts) mkFonts;
  inherit (lix.sources.packages) pkgsFrom;

  context = mkContext {
    inherit config;
    dom = "editor";
    mod = "vscode";
    kind = "editor";
  };
  inherit (context) cfg;

  tools = pkgsFrom {
    inherit inputs pkgs;
    sources = {
      coreutils = null;
      dms = "dank-material-shell";
      vscode-fhs = null;
      vscode-insiders =
        if cfg.insiders
        then "vscode-insiders"
        else null;
    };
    # required = true;
  };

  bins = let
    mkCore = cmd: "${tools.coreutils.paths.binary}/${cmd}";
    coreutils = genAttrs ["chmod" "cp" "dirname" "install" "mkdir" "rm"] mkCore;
  in
    coreutils // {rmf = "${coreutils.rm} -rf";};

  args = {
    inherit bins cfg config context entryAfter inputs lix mkDefault pkgs paths tools mkMerge;
    fonts = mkFonts {inherit host user;};
    json = pkgs.formats.json {};
  };

  overrides = {
    settings = import ./settings args;
    keybindings = import ./control args;
    extensions = import ./extensions args;
  };
  app = import ./base (args // {inherit overrides;});

  resolved = userApplicationConfig {
    inherit context user pkgs;
    name = "vscode";
    category = "gui";
    customPackage = tools.vscode-fhs.package;
    resolutionHints = ["code" "vscode" "vscode-fhs" "vscode-insiders"];
    requiresWayland = true;
    #? Correct the resolved Insiders package metadata so desktop/icon/CLI
    #? identity is Insiders rather than stable `code`.
    extraPackages = optional cfg.insiders (
      tools.vscode-insiders.package.overrideAttrs (old: {
        passthru =
          (old.passthru or {})
          // {
            executableName = "code-insiders";
            longName = "Visual Studio Code - Insiders";
            iconName = "vscode-insiders";
          };
      })
    );
    debug = false;
  };
in
  mkConfig {
    inherit context;
    options = {
      enable = mkEnable {
        inherit context;
        condition = resolved.enable;
      };
      insiders = mkTrue "Whether to use Visual Studio Code Insiders instead of the standard release.";
      #TODO: what exactly is happening here?
      withExtensions = overrides.settings.options;
    };

    outputs = {
      home = resolved.home // (import ./activation.nix (args // app));
    };
  }
