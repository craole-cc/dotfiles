{ lib, pkgs, ... }:

{
  imports = [ ];
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
