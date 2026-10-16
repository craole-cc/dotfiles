pkgs: let
  inherit (pkgs) dgop;
in {
  plugins = {
    nixMonitor.enable = true;
    systemMonitor.enable = true;
  };

  packages = [dgop];
}
