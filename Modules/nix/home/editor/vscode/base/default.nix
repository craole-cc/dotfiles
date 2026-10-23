{overrides, ...} @ args: let
  defaults = import ./imports.nix args;
  dms = import ./dms.nix args;
  profile = import ./profile.nix (args // {inherit defaults overrides;});
  app = import ./variant.nix (args // {inherit dms profile;});
in {inherit dms defaults app profile;}
