{overrides, ...} @ args: let
  defaults = import ./imports.nix args;
  dms = import ./dms.nix args;
  profile = import ./profile.nix (args // {inherit defaults overrides;});
  app = import ./variant.nix (args // {inherit dms profile;});
  activation = import ./activation.nix (args // {inherit dms app profile;});
in {inherit activation dms defaults app profile;}
