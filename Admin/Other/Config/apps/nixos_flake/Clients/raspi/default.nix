{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4

    ./services
    ./hardware-configuration.nix

    ../common/global
    ../common/users/craole
  ];

  # Static IP address
  networking = {
    hostName = "raspi";
    useDHCP = true;
    interfaces.eth0 = {
      useDHCP = true;
      wakeOnLan.enable = true;

      ipv4.addresses = [
        {
          address = "192.168.0.11";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2804:14d:8084:a484::1";
          prefixLength = 64;
        }
      ];
    };
  };

  # Enable argonone fan daemon
  services.hardware.argonone.enable = true;

  # Workaround for https://github.com/NixOS/nixpkgs/issues/154163
  nixpkgs.overlays = [
    (final: prev: {
      makeModulesClosure = x: prev.makeModulesClosure (x // {allowMissing = true;});
    })
  ];

  system.stateVersion = "23.05";
}
