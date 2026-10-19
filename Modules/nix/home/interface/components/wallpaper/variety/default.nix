/*
Variety wallpaper manager, declaratively (home-manager module).

Layout
  default.nix      entry point; import this one
  options.nix      resolved option declarations
  config.nix       turns options into: variety.conf, wrapper package, activation
  defaults.nix     variety.conf keys that have no dedicated option
  scripts.nix      packages the existing Libraries/posix/wallpaper hooks
  sources.nix      the list of wallpaper sources (pure data)
  preferences.nix  personal values for the options above; delete or replace freely

The parent wallpaper component imports this module and controls enablement.
*/
{
  config,
  inputs,
  lix,
  paths,
  pkgs,
  ...
} @ args: let
  context = mkContext {
    inherit config;
    dom = "media";
    sub = "wallpaper";
    mod = "variety";
  };
  inherit (context) cfg;

  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.applications.construction) mkScriptWrappers;
  inherit (lix.attrsets.construction) genAttrs;
  inherit (lix.filesystem.construction) concatPath;
  inherit (lix.sources.packages) pkgsFrom;

  tool = let
    defined = pkgsFrom {
      inherit inputs pkgs;
      sources = {variety = null;};
      required = true;
    };

    custom = let
      names = ["variety_next" "variety_previous" "variety_love"];
      scripts = genAttrs names (name:
        concatPath {
          root = paths.store.lib.sh;
          stem = ["wallpaper" name];
        });
      packages = mkScriptWrappers {inherit pkgs scripts;};
    in {inherit names scripts packages;};
  in {inherit defined custom;};
  args' = args // {inherit cfg context tool;};
in
  mkConfig {
    inherit context;
    options = import ./options.nix args';
    outputs = (import ./config.nix args') // (import ./preferences.nix args');
  }
