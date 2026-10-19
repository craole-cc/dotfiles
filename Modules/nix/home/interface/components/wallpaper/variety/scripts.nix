# Packages the hook scripts so variety.conf can point straight at the Nix
# store. Variety never needs to write to them, which avoids the read-only
# symlink problem a profile scripts/ folder would have.
{
  pkgs,
  lix,
  paths,
  runtimeInputs ? [],
}: let
  inherit (lix.filesystem.access) readFile;
  inherit (lix.strings.construction) makeBinPath;
  wallpaperLib = paths.store.lib.sh + "/wallpaper";
  mk = name: file:
    pkgs.writeShellScript name ''
      export PATH="$PATH:${makeBinPath runtimeInputs}"
      ${readFile file}
    '';
in {
  setWallpaper = mk "variety-set-wallpaper" "${wallpaperLib}/variety_set";
  getWallpaper = mk "variety-get-wallpaper" "${wallpaperLib}/variety_get";
}
