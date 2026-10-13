{
  config,
  context,
  lix,
  ...
}: let
  inherit (lix.modules.construction) mkIf;
  inherit (context) wantsDmsShell;
in {
  # Keep behavioral configuration in Home Manager, but delegate terminal
  # colors to DMS when DMS owns the desktop shell. DMS regenerates the
  # `dankcolors` Ghostty theme from its active Material/Matugen palette.
  settings = mkIf wantsDmsShell.condition {
    theme = "dankcolors";
    config-file = "?${config.xdg.configHome}/ghostty/dotdots-opacity";
  };
}
