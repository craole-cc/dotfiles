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
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.attrsets.construction) genAttrs;
  inherit (lix.modules.construction) mkConfig mkContext mkMerge mkDefault;
  inherit (lix.options.construction) mkEnable mkFalse mkTrue;
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
      jaq = null;
      vscode-fhs = null;
      vscode-insiders =
        if cfg.insiders
        then "vscode-insiders"
        else null;
    };
    required = true;
  };

  bins = let
    coreutils =
      genAttrs ["chmod" "cp" "dirname" "install" "mkdir" "rm"]
      (command: "${tools.coreutils.paths.binary}/${command}");
  in
    mergeSafe [
      coreutils
      tools.binaries
      {rmf = "${coreutils.rm} -rf";}
    ];

  args = {
    inherit
      bins
      cfg
      config
      context
      entryAfter
      inputs
      lix
      mkDefault
      pkgs
      paths
      tools
      mkMerge
      ;
    fonts = mkFonts {inherit host user;};
    json = pkgs.formats.json {};
  };

  profile = import ./settings args;
  build = import ./build (args // {profile = profile.output;});
  app = userApplicationConfig {
    inherit context user pkgs;
    name = "vscode";
    category = "gui";
    customPackage = tools.vscode-fhs.package;
    resolutionHints = [
      "code"
      "vscode"
      "vscode-fhs"
      "vscode-insiders"
    ];
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
        condition = app.enable;
      };
      insiders = mkTrue "Whether to use Visual Studio Code Insiders instead of the standard release.";
      importJSON = mkFalse "Import fallback VS Code settings and keybindings from the saved JSON configuration.";
      features = profile.options;
    };

    outputs = {
      home = app.home // build.activation;
    };
  }
