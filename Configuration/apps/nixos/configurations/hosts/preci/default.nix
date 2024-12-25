{
  system = "x86_64-linux";
  id = "0ab86678";
  stateVersion = "24.05";
  base = "laptop";
  desktop = "plasma";
  preferredRepo = "unstable";
  allowUnfree = true;
  allowAliases = true;
  # allowHomeManager = false;
  backupFileExtension = "BaC";
  extraPkgConfig = { };
  extraPkgAttrs = { };

  capabilities = [
    "ai"
    "audio"
    "battery"
    "bluetooth"
    "video"
    "storage"
    "mouse"
    "remote"
    "touchpad"
    "wired"
    "wireless"
  ];
  context = [
    "development"
    "media"
    "productivity"
  ];
  cpu = {
    brand = "intel";
    arch = "x86_64-linux";
    mode = "ondemand";
  };
  gpu = {
    brand = "intel";
  };
  location = {
    latitude = 18.015;
    longitude = 77.49;
    timeZone = "America/Jamaica";
    defaultLocale = "en_US.UTF-8";
  };
  keyboard = {
    modifier = "SUPER_L";
    swapCapsEscape = true;
  };
  access = {
    ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNDko91cBLITGetT4wRmV1ihq9c/L20sUSLPxbfI0vE root@victus";
    age = "age1j5cug724x386nygk8dhc38tujhzhp9nyzyelzl0yaz3ndgtq3qwqxtkfpv";
    firewall = {
      enable = true;
      tcp = {
        ranges = [
          {
            from = 49160;
            to = 65534;
          } # Allowing a range for random port selection
        ];
        ports = [
          22
          80
          443
          1678
          1876
        ];
      };
      udp = {
        ranges = [
          {
            from = 49160;
            to = 65534;
          } # Allowing a range for random port selection
        ];
        ports = [ ];
      };
    };
  };
  people = [
    {
      name = "craole";
      admin = true;
      autoLogin = true;
      # enable = true; #? This defaults to true if unset
    }
    {
      name = "cc";
      admin = true;
    }
    {
      name = "qyatt";
      # enable = false;
      admin = false;
    }
  ];
  ollama = {
    enable = true;
    models = [
      "mistral-nemo"
      "yi-coder:9b"
    ];
  };
  boot = {
    modules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "sr_mod"
      "sdhci_pci"
    ];
  };
  devices = {
    luks = {
      "luks-d6bafe54-e55b-49b8-ab7c-18380939f56f".device =
        "/dev/disk/by-uuid/d6bafe54-e55b-49b8-ab7c-18380939f56f";
      "luks-540965a0-c573-42f9-8d14-2ae37c3715e6".device =
        "/dev/disk/by-uuid/540965a0-c573-42f9-8d14-2ae37c3715e6";
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/5fe83d0f-15a3-4abf-abb2-2ba02cc9195d";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/542E-33C1";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/d1aa80d2-ba1f-412f-9d81-5c5f5c6a839d"; }
    ];

    network = [
      "eno1"
      "wlp3s0"
    ];
  };
}
