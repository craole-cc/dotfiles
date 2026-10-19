# Personal values for the options in options.nix. Everything uses mkDefault,
# so any other module can override it without mkForce.
{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
  home = config.home.homeDirectory;
  legacy = "${home}/.config/variety";
in {
  programs.variety = {
    # `enable` is deliberately not set here: the wrapper in ../default.nix
    # turns it on, so the existing wallpaper-component condition decides.
    profile = lib.mkDefault "declarative";

    # Reuse the images already collected by the default profile.
    # Only run one Variety instance at a time while these are shared.
    folders = {
      downloaded = lib.mkDefault "${legacy}/Downloaded";
      fetched = lib.mkDefault "${legacy}/Fetched";
      favorites = lib.mkDefault "${home}/Pictures/Wallpapers/variety";
    };

    clock = {
      enable = mkDefault true;
      font = mkDefault "Rubik Heavy 70"; #TODO: This should use fonts.clock
    };

    sources = mkDefault (import ./sources.nix {inherit home;});
  };
}
