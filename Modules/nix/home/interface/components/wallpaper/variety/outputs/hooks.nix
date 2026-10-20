# Build the backend hooks unless the user supplies custom executable paths.
{
  cfg,
  pkgs,
  lix,
  tool,
}: let
  inherit (lix.strings.transformation) escapeShellArg;
  inherit (pkgs) writeShellScript;

  hook = action:
    if cfg.scripts.${action} != null
    then toString cfg.scripts.${action}
    else
      writeShellScript "variety-${action}-wallpaper" ''
        exec ${tool.varietyctl.exe} ${escapeShellArg action} "$@"
      '';
in {
  setWallpaper = hook "set";
  getWallpaper = hook "get";
  setLockscreen = hook "set-lockscreen";
}
