{lix, ...} @ args: let
  inherit (lix.lists.transformation) flatten;

  load = path: import path args;
  entries = map load [
    ./global.nix
    ./editor.nix
    ./terminal.nix
    ./ui.nix
    ./configuration.nix
  ];
in {
  keybindings = flatten (map (entry: entry.keybindings or []) entries);
}
