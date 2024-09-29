{ self, home-manager, nixpkgs, templates, ... }:
let
  inherit (nixpkgs) lib;

  genModules = hostName: { homeDirectory, ... }:
    { config, pkgs, ... }: {
      imports = [
        (../servers + "/${hostName}")
      ];
      nix.registry = {
        nixpkgs.flake = nixpkgs;
        p.flake = nixpkgs;
        pkgs.flake = nixpkgs;
        templates.flake = templates;
      };

      home = {
        inherit homeDirectory;
        sessionVariables.NIX_PATH = lib.concatStringsSep ":" [
          "nixpkgs=${config.xdg.dataHome}/nixpkgs"
          "nixpkgs-overlays=${config.xdg.dataHome}/overlays"
        ];
      };
      
      xdg = {
        dataFile = {
          nixpkgs.source = nixpkgs;
          overlays.source = ../middleware;
        };
        configFile."nix/nix.conf".text = ''
          flake-registry = ${config.xdg.configHome}/nix/registry.json
        '';
      };
    };

  genConfiguration = hostName: { hostPlatform, ... }@attrs:
    home-manager.lib.homeManagerConfiguration {
      pkgs = self.pkgs.${hostPlatform};
      modules = [ (genModules hostName attrs) ];
    };
in
lib.mapAttrs genConfiguration (self.hosts.homeManager or { })
