{
  mkGroup,
  mkEntry,
  fromJSON,
  ...
}:
mkGroup {
  name = "linting";
  description = "Linting";
  default = true;
  features = [
    (mkEntry {
      userSettings = fromJSON ''
        {
          "lintRunner.tools": {
            "shellcheck": {
              "kind": "diagnostic",
              "command": "shellcheck",
              "args": [
                "--enable=all",
                "--format=gcc",
                "''${file}"
              ],
              "successExitCodes": [
                0,
                1
              ],
              "parser": {
                "flags": "gm",
                "pattern": "^.+?:(?<line>\\d+):(?<col>\\d+): (?<severity>error|warning|note): (?<message>.+)$"
              }
            },
            "statix": {
              "kind": "diagnostic",
              "command": "statix",
              "args": [
                "check",
                "--format",
                "errfmt",
                "''${file}"
              ],
              "successExitCodes": [
                0,
                1
              ],
              "parser": {
                "flags": "gm",
                "pattern": "^.+?>(?<line>\\d+):(?<col>\\d+):[WE]:(?<code>\\d+):(?<message>.+)$"
              }
            }
          },
          "lintRunner.targets": [
            {
              "name": "Nix",
              "match": {
                "languages": [
                  "nix"
                ],
                "files": [
                  "**/*.nix"
                ]
              },
              "onOpen": {
                "strategy": "sequence",
                "tools": [
                  "statix"
                ]
              },
              "onSave": {
                "strategy": "sequence",
                "tools": [
                  "statix"
                ]
              },
              "manual": {
                "strategy": "sequence",
                "tools": [
                  "statix"
                ]
              }
            },
            {
              "name": "Shell",
              "match": {
                "languages": [
                  "shellscript"
                ]
              },
              "onOpen": {
                "strategy": "sequence",
                "tools": [
                  "shellcheck"
                ]
              },
              "onSave": {
                "strategy": "sequence",
                "tools": [
                  "shellcheck"
                ]
              }
            }
          ]
        }
      '';
    })
  ];
}
