args: let
  dms = import ./dms.nix args;
  inherit (args) profile;
  app = import ./variant.nix (args // {inherit dms profile;});
  activation = import ./activation.nix (args // {inherit dms app profile;});
in {inherit activation dms app profile;}
