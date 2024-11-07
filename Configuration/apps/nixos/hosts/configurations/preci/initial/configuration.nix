{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  DOTS = "$HOME/Documents/dotfiles";
  DOTSRC = DOTS + "/.dotsrc";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.timeout = 1;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "craole"
        "@wheel"
      ];
    };
  };

  networking = {
    networkmanager.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = lib.mkDefault true;
  };

  hardware = {
    pulseaudio.enable = lib.mkDefault false;
    bluetooth = {
      enable = lib.mkDefault true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  system = {
    stateVersion = "24.05";
  };

  time = {
    timeZone = lib.mkDefault "America/Jamaica";
    hardwareClockInLocalTime = lib.mkDefault true;
  };

  location = {
    latitude = 18.015;
    longitude = 77.49;
    provider = "manual";
  };

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
  };

  security = {
    sudo = {
      execWheelOnly = true;
      extraRules = [
        {
          users = [ "craole" ];
          commands = [
            {
              command = "ALL";
              options = [
                "SETENV"
                "NOPASSWD"
              ];
            }
          ];
        }
      ];
    };
    rtkit.enable = true;
  };

  console = {
    packages = [ pkgs.terminus_font ];
    font = "ter-u32n";
    earlySetup = true;
    useXkbConfig = true;
  };

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "craole";
      };
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    desktopManager = {
      plasma6.enable = true;
    };

    kmscon = {
      enable = true;
      autologinUser = "craole";
    };

    blueman = {
      enable = true;
    };

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="hidraw", GROUP="users", MODE="0660", TAG+="uaccess"
    '';

    upower = {
      enable = true;
    };

    redshift = {
      enable = true;
      brightness = {
        day = "1";
        night = "0.75";
      };
      temperature = {
        day = 5500;
        night = 3800;
      };
    };

    libinput = {
      enable = true;
    };

    tailscale = {
      enable = true;
    };

    ollama = {
      enable = true;
      loadModels = [
        "mistral-nemo"
        # "yi-coder:9b"
      ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire."92-low-latency" = {
        context.properties.default.clock = {
          rate = 48000;
          quantum = 32;
          min-quantum = 32;
          max-quantum = 32;
        };
      };
    };
  };

  programs = {
    bash = {
      shellInit = ''
        [ -f ${DOTSRC} ] && . "${DOTSRC}"
      '';
    };
    hyprland.enable = true;
    hyprlock.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    direnv = {
      enable = true;
      silent = true;
    };
  };

  environment = {

    pathsToLink = [
      #TODO: This doesnt work
      DOTS
    ];
    systemPackages = with pkgs; [
      #| Core Utilities
      usbutils
      uutils-coreutils-noprefix
      busybox
      bat
      fzf
      ripgrep
      ripgrep-all
      sd
      tldr
      fd
      jq

      #| Development
      nil
      nixd
      nixfmt-rfc-style
      nix-info
      shellcheck
      shfmt

      #| Filesystem
      dust
      eza

      #| Network
      speedtest-go

      #| System
      easyeffects
      pavucontrol
      qjackctl
      brightnessctl
    ];
    variables = {
      inherit DOTS;
      PATH = "$PATH:$DOTS/Bin";
      NIXOS_CONFIG = DOTS;
      # LESS = "-R";
      # COLORTERM = "truecolor";
      # TERM = "xterm-256color";
    };
    shellAliases = {
      h = "history";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      x = "exit";
    };
  };
}
