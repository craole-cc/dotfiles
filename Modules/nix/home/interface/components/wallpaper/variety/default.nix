/*
Variety wallpaper manager, declaratively (home-manager module).

Layout
  default.nix      entry point; import this one
  options.nix      option declarations (programs.variety.*)
  config.nix       turns options into: variety.conf, wrapper package, activation
  lib.nix          pure helpers that render the options into variety.conf syntax
  defaults.nix     variety.conf keys that have no dedicated option
  scripts.nix      packages the existing Libraries/posix/wallpaper hooks
  sources.nix      the list of wallpaper sources (pure data)
  preferences.nix  personal values for the options above; delete or replace freely

The parent wallpaper component imports this module and controls enablement.
*/
{
  config,
  wallpaper,
  inputs,
  lix,
  user,
  paths,
  pkgs,
  ...
}: let
  context = mkContext {
    inherit config;
    dom = "media";
    sub = "wallpaper";
    mod = "variety";
  };
  inherit (context) cfg;

  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.applications.construction) mkScriptWrapper;
  inherit (lix.attrsets.access) attrValues;
  inherit (lix.attrsets.construction) genAttrs optionalAttrs;
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.filesystem.construction) concat;
  inherit (lix.modules.construction) mkIf;
  inherit (lix.options.construction) mkEnable;
  inherit (lix.lists.predicates) isIn;
  inherit (lix.sources.packages) pkgsFrom;

  tool = let
    defined = pkgsFrom {
      inherit inputs pkgs;
      sources = optionalAttrs cfg.enable {variety = null;};
    };

    custom = let
      names = ["variety_next" "variety_previous" "variety_love"];
      scripts = genAttrs names (name:
        concat {
          root = paths.store.lib.sh;
          stem = ["wallpaper" name];
        });
      resolved = mapAttrs (name: script: mkScriptWrapper {inherit pkgs name script;}) scripts;
      binaries = mapAttrs (name: wrapper: "${wrapper}/bin/${name}") resolved;
      packages = attrValues resolved;
    in {inherit names scripts binaries packages;};

    bins = let
      inherit (defined.binaries) variety;
      coreutils = "${defined.coreutils.paths.binary}";
      rm = "${coreutils}/rm";
      rmf = "${rm} --force";
    in
      {inherit variety rm rmf;} // custom.binaries;

    packages = defined.packages ++ custom.packages;
  in {inherit defined bins custom packages;};
  # TODO: Wire these in
  # imports = [
  #   ./options.nix
  #   ./config.nix
  #   ./preferences.nix
  # ];
in
  mkConfig {
    inherit context;

    options = {
      enable = mkEnable {
        inherit context;
        condition =
          wallpaper.cfg.enable
          && isIn "variety" (user.packages.wallpaper or []);
      };
    };

    outputs = {
      home = mkIf cfg.enable {
        inherit (tool) packages;
      };
    };
  }
