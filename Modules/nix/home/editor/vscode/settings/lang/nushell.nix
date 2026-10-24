{
  user,
  lix,
  cfg,
  context,
  mkEnable,
  requires,
  ...
}: let
  inherit (lix.lists.predicates) isIn;

  mod = "nushell";
  enable = cfg.nushell.enable;

in {
  inherit enable;
  options.nushell.enable = mkEnable {
    inherit context;
    condition = requires "nushell";
  };
  extensions = [
    "thenuprojectcontributors.vscode-nushell-lang"
  ];
}
