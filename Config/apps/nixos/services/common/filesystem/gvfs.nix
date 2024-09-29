{ lib, pkgs, ... }:{
  #| Automount USB
  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome3.gvfs;
  };
}