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
  imports = [
    ./options.nix
    ./config.nix
    ./preferences.nix
  ];
}
