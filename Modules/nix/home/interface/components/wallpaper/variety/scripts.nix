# Packages the hook scripts so variety.conf can point straight at the Nix
# store. Variety never needs to write to them, which avoids the read-only
# symlink problem a profile scripts/ folder would have.
{ pkgs, lib, runtimeInputs ? [ ] }:
let
  mk =
    name: file:
    pkgs.writeShellScript name ''
      export PATH="$PATH:${lib.makeBinPath runtimeInputs}"
      ${builtins.readFile file}
    '';
in
{
  setWallpaper = mk "variety-set-wallpaper" ./scripts/set_wallpaper;
  getWallpaper = mk "variety-get-wallpaper" ./scripts/get_wallpaper;
}
