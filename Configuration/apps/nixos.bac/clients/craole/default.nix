{ config, impermanence, lib, pkgs, ... }:
with lib;
{
  age.secrets.craolePassword.file = ./password.age;

  users.groups.craole.gid = config.users.users.craole.uid;

  users.users.craole = {
    createHome = true;
    description = "Craig 'Craole' Cole";
    group = "craole";
    extraGroups = [ "wheel" "dialout" ]
      ++ optionals config.hardware.i2c.enable [ "i2c" ]
      ++ optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ optionals config.programs.sway.enable [ "input" "video" ]
      ++ optionals config.services.unbound.enable [ "unbound" ]
      ++ optionals config.sound.enable [ "audio" ]
      ++ optionals config.virtualisation.docker.enable [ "docker" ]
      ++ optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
      ++ optionals config.virtualisation.kvmgt.enable [ "kvm" ]
      ++ optionals config.virtualisation.podman.enable [ "podman" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQgTWfmR/Z4Szahx/uahdPqvEP/e/KQ1dKUYLenLuY2 craole.personal"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFAvxz7tBCov9310ucqrVeAS0aSWCVh5sSsLjH/62lIldFPd7JVK5y+f5VETycoRy9aQSzzlb4wsXtCX0WMtRx8tWbeV4MVXHSDROQEI1QpWM5BPgrLdNB5zR+czjSb0It+3XrzzOiu1RaIY/48EEhxxshghLEVQqwHplObQI9yzdxfVPD9ZOqbxQRi6hYm9uEU3DcAONhLDAIlaDltmZVr7Vfg3P+eucO+QJ7/aLuochWLxLX/NjBsihYLrZIY+y1JAP2jm+dkGVTimozr/zwopO4y4+FlLK71ZbE1xlLX/UZHdfN00rmmZwzeTN+S7+H3cQSCQO6p6qmk9fT94sr9S7pKa8/fSr/1q7wbvKcoOW0hYal4XHnuON58+kA7thgZgFEji6o9KqWsss1wqx/XLYu2ThU6OpplPzhL+AwaH1uQpmoQ5ge29Emadv42R1jw0js2nljA4sJFybFmV0LJwORvqjaYuEj2peS40BT3eI+51plD85p//gmTeT3W7zqR8KB5bWK1xzWReSOI0Vg6PGiBPSA38dH5V7OZXDjZRnlE1WTD3E7MVKGhQDwQHoQdAvNSG7LyBfK7eprCTQAR/LkTaIQrCxLsIkzoSor5ZkG6P+QWN+HaN9YFJT6p7TtHbzZqpRkKAcVkNwXcGOyIw4ofybmUUEQ8O5Y8CC9Fw== cardno:000610250089"
    ];
    shell = pkgs.fish;
    uid = 8888;

    passwordFile = config.age.secrets.craolePassword.path;
  };

  programs._1password-gui.polkitPolicyOwners = [ "craole" ];

  home-manager.users.craole = {
    imports = [
    #   impermanence.home-manager.impermanence
    #   ./core
    #   ./dev
    #   ./modules
    # ] ++ optionals config.programs.sway.enable [
    #   ./graphical
    #   ./graphical/sway
    # ] ++ optionals config.services.xserver.windowManager.i3.enable [
    #   ./graphical
    #   ./graphical/i3
    ];

    home.username = config.users.users.craole.name;
    home.uid = config.users.users.craole.uid;
  };
}
