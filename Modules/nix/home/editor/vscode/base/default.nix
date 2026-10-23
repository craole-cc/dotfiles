{overrides, ...} @ args: let
  defaults = import ./imports.nix args;
  profile = import ./profile.nix (args // {inherit defaults overrides;});
  app = import ./variant.nix (args // {inherit profile;});
  dms = import ./dms.nix (args // {inherit app;});
in {inherit dms defaults app profile;}
