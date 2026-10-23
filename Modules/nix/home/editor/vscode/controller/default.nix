{lix, ...} @ args: let
  inherit (lix.lists.transformation) flatten;
in {
  keybindings = flatten (map (entry: entry.keybindings or []) (map import [
      ./editor.nix
      ./terminal.nix
      ./ui.nix
      ./configuration.nix
    ]
    args));
}
