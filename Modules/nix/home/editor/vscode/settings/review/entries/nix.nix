{
  mkGroup,
  mkEntry,
  ...
}: let
  nixLsp = mkEntry {
    enable = true;
    extensions = [
      #? basic Nix syntax
      "bbenoist.nix"
      #? Nix LSP, formatting, eval
      "jnoortheen.nix-ide"
      #? improved Nix highlighting
      "jeff-hykin.better-nix-syntax"
      #? Alejandra formatter integration
      # "kamadorueda.alejandra"
    ];
    userSettings = {
      "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.serverSettings"."nixd" = {
        "formatting"."command" = ["alejandra" "-q" "-"];
        "diagnostic"."suppress" = ["sema-primop-overridden"];
      };
    };
  };

  direnv = mkEntry {
    enable = true;
    extensions = [
      #? direnv environment integration
      "mkhl.direnv"
    ];
    userSettings = {
      "direnv.restart.automatic" = true;
    };
  };
in {entries = {inherit nixLsp direnv;};}
