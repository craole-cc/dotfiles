# Personal values for the options in options.nix. Everything uses mkDefault,
# so any other module can override it without mkForce.
{
  config,
  context,
  lix,
  paths,
  user,
  ...
}: let
  inherit (lix.modules.construction) mkDefault;
  inherit (lix.attrsets.transformation) setAttrByPath;
  home = config.home.homeDirectory;
  legacy = "${home}/.config/variety";
in
  setAttrByPath (context.path ++ ["explicit"]) {
    # Reuse the images already collected by the default profile.
    # Only run one Variety instance at a time while these are shared.
    folders = {
      downloaded = mkDefault "${legacy}/Downloaded";
      fetched = mkDefault "${legacy}/Fetched";
      favorites = mkDefault "${home}/Pictures/Wallpapers/variety";
    };

    clock = {
      enable = mkDefault true;
      font = mkDefault "Rubik Heavy 70"; # TODO: This should use fonts.clock
    };

    sources = mkDefault (
      import ./sources.nix {
        inherit home lix paths user;
      }
    );
  }
