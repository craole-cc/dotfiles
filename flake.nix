{
  description = "NixOS Configuration Flake";
  inputs = {
    nixed.url = "github:Craole/nixed";
    nixosStable.url = "nixpkgs/nixos-24.05";
    nixosUnstable.url = "nixpkgs/nixos-unstable";
    nixosHardware.url = "github:NixOS/nixos-hardware";
    nixDarwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixosUnstable";
    };
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixosUnstable";
    };
    plasmaManager = {
      url = "github:pjones/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixosUnstable";
        home-manager.follows = "homeManager";
      };
    };
    stylix.url = "github:danth/stylix";
  };
  outputs =
    { self, ... }@inputs:
    let
      mkConfig =
        {
          name,
          system,
          preferredRepo ? "unstable",
          allowUnfree ? true,
          allowAliases ? true,
          allowHomeManager ? true,
          backupFileExtension ? "BaC",
          enableDots ? false,
          extraPkgConfig ? { },
          extraPkgAttrs ? { },
          extraArgs ? { },
          extraMods ? { },
          ui ? {
            env = "hyprland";
          },
        }:
        let
          paths =
            let
              flake = {
                local = "/home/craole/Documents/dotfiles";
                store = ./.;
              };
              names = {
                modules = "/Configuration/apps/nixos";
                scripts = "/Bin";
                libraries = "/libraries";
                hosts = "/hosts/configurations";
                mkCore = "/helpers/makeCoreConfig.nix";
                uiCore = "/apps/ui/core";
                uiHome = "/apps/ui/home";
              };
              scripts = {
                local = flake.local + names.scripts;
                store = flake.store + names.scripts;
              };
              modules = {
                local = flake.local + names.modules;
                store = flake.store + names.modules;
              };
              libraries = {
                local = modules.local + names.libraries;
                store = modules.store + names.libraries;
              };
            in
            {
              inherit
                flake
                names
                scripts
                modules
                libraries
                ;
            };
          specialModules =
            let
              conf = {
                environment = {
                  variables = with paths; {
                    DOTS = flake.local;
                    DOTS_RC = flake.local + "/.dotsrc";
                    DOTS_BIN = scripts.local;
                    DOTS_NIX = modules.local;
                    NIXOS_FLAKE = flake.local;
                    NIXOS_CONFIG = with paths; modules.local + names.hosts + "/${name}";
                  };
                  shellAliases = {
                    Flake = ''pushd ${paths.flake.local} && { { { command -v geet && geet ;} || git add --all; git commit --message "Flake Update" ;} ; sudo nixos-rebuild switch --flake . --show-trace ;}; popd'';
                    Flush = ''sudo nix-collect-garbage --delete-old; sudo nix-store --gc'';
                    Flash = ''geet --path ${paths.flake.local} && sudo nixos-rebuild switch --flake ${paths.flake.local} --show-trace'';
                    Flick = ''Flush && Flash && Reboot'';
                    Reboot = ''leave --reboot'';
                    Reload = ''leave --logout'';
                    Retire = ''leave --shutdown'';
                    Q = ''kill -KILL "$(ps -o ppid= -p $$)"'';
                    q = ''leave --terminal'';
                    ".." = "cd .. || return 1";
                    "..." = "cd ../.. || return 1";
                    "...." = "cd ../../.. || return 1";
                    "....." = "cd ../../../.. || return 1";
                    h = "history";
                  };
                  extraInit = ''[ -f "$DOTS_RC" ] && . "$DOTS_RC"'';
                };
              };
              core =
                with inputs;
                [
                  paths.modules.store
                  conf
                  stylix.nixosModules.stylix
                ]
                ++ (import (with paths; modules.store + names.uiCore) { inherit (ui) env; });
              home =
                with inputs;
                [ ]
                ++ (
                  if ui.env == "hyprland" then
                    [ ]
                  else if ui.env == "plasma" then
                    [ plasmaManager.homeManagerModules.plasma-manager ]
                  else if ui.env == "xfce" then
                    [ ]
                  else
                    [ ]
                );
            in
            { inherit core home; } // extraMods;

          specialArgs = {
            inherit paths ui;
            mods = specialModules;
            flake = self;
          } // extraArgs;
        in
        import (with paths; libraries.store + names.mkCore) {
          inherit (inputs)
            nixosStable
            nixosUnstable
            homeManager
            nixDarwin
            ;
          inherit
            name
            system
            preferredRepo
            allowUnfree
            allowAliases
            allowHomeManager
            backupFileExtension
            enableDots
            extraPkgConfig
            extraPkgAttrs
            specialArgs
            specialModules
            ;
        };
    in
    {
      nixosConfigurations = {
        preci = mkConfig {
          name = "preci";
          system = "x86_64-linux";
          ui.env = "plasma";
        };
        dbook = mkConfig {
          name = "dbook";
          system = "x86_64-linux";
          ui.env = "xfce";
        };
      };

      # darwinConfigurations = {
      #   MBPoNine = mkCore {
      #     name = "MBPoNine";
      #     system = "x86_64-darwin";
      #   };
      # };

      # TODO create mkHome for standalone home manager configs
      # homeConfigurations = {
      #   craole = mkHome {
      #     name = "craole";
      #   };
      # };
    };
}
