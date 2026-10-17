{
  apps,
  config,
  lix,
  pkgs,
  user,
  ...
}: let
  inherit (lix.applications.generators) userApplicationConfig;
  inherit (lix.lists.aggregation) concatMap;
  inherit (lix.lists.predicates) elem;
  inherit (lix.lists.selection) filter;
  # These modules configure and install their own packages. Other selected
  # terminals still need to be installed, regardless of their list position.
  dedicated = ["ghostty" "foot" "kitty"];
  additional = filter (entry: !(elem entry.name dedicated)) apps.terminal.ordered;
in {
  home.packages =
    concatMap (
      entry:
        (userApplicationConfig {
          inherit config pkgs user;
          name = entry.name;
          kind = "terminal";
        }).home.packages
    )
    additional;
}
