_: {
  extensions = [
    "bbenoist.Nix"
    "jnoortheen.nix-ide"
    "kamadorueda.alejandra"
    "vix.lint-runner"
  ];
  settings = let
    server = "nixd";
  in {
    "[nix]" = {
      editor = {
        defaultFormatter = "jnoortheen.nix-ide";
      };
    };
    nix = {
      enableLanguageServer = true;
      serverPath = server;
      serverSettings = {
        "${server}"."formatting"."command" = ["alejandra" "-q" "-"];
      };
    };

    lintRunner = {
      tools = {
        statix = {
          kind = "diagnostic";
          command = "statix";
          args = ["check" "--format" "errfmt" "\${file}"];
          successExitCodes = [0 1];
          parser = {
            flags = "gm";
            pattern = "^.+?>(?<line>\\\\d+):(?<col>\\\\d+):[WE]:(?<code>\\\\d+):(?<message>.+)$";
          };
        };
      };

      targets = [
        {
          name = "Nix";
          match = {
            languages = ["nix"];
            files = ["**/*.nix"];
          };
          onOpen = {
            strategy = "sequence";
            tools = ["statix"];
          };
          onSave = {
            strategy = "sequence";
            tools = ["statix"];
          };
          manual = {
            strategy = "sequence";
            tools = ["statix"];
          };
        }
      ];
    };
  };
}
