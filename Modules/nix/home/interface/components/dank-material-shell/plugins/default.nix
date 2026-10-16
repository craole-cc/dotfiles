{
  bins,
  config,
  inputs,
  lix,
  pkgs,
}: let
  inherit (lix.lists.aggregation) concatMap foldl';
  inherit (lix.lists.transformation) unique;

  categories = [
    (import ./desktop.nix {inherit config pkgs;})
    (import ./media.nix pkgs)
    (import ./messengers.nix {inherit inputs lix pkgs;})
    (import ./monitoring.nix pkgs)
    (import ./productivity.nix)
    (import ./utilities.nix)
    (import ./wallpapers.nix pkgs)
  ];
in {
  plugins = foldl' (plugins: category: plugins // category.plugins) {} categories;
  packages = unique (concatMap (category: category.packages or []) categories);
  activation = import ./activation.nix {inherit bins config inputs lix pkgs;};
}
