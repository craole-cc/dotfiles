{
  mkGroup,
  mkEntry,
  ...
} @ args: let
  markup = import ./entries/markup.nix args;
  nix = import ./entries/nix.nix args;
  scripting = import ./entries/scripting.nix args;
  systems = import ./entries/systems.nix args;
  web = import ./entries/web.nix args;
in
  mkGroup {
    name = "languages";
    description = "Languages (A-Z)";
    default = true;
    features =
      [
        (mkEntry {
          userSettings = builtins.fromJSON ''
            {
              "[cypher]": {
                "editor.semanticHighlighting.enabled": true
              },
              "[css]": {
                "editor.defaultFormatter": "biomejs.biome"
              },
              "[scss]": {
                "editor.defaultFormatter": "biomejs.biome"
              },
              "cssvar.files": [
                "./node_modules/open-props/open-props.min.css",
                "assets/styles/variables.css",
                "style.css"
              ],
              "cssvar.ignore": [],
              "cssvar.extensions": [
                "css",
                "postcss",
                "jsx",
                "tsx"
              ],
              "tailwindCSS.includeLanguages": {
                "plaintext": "html"
              },
              "[html]": {
                "editor.defaultFormatter": "biomejs.biome"
              },
              "[javascript]": {
                "editor.defaultFormatter": "biomejs.biome"
              },
              "json.schemas": [
                {
                  "fileMatch": [
                    "**/*.json",
                    "**/*.jsonc"
                  ],
                  "schema": {
                    "allowTrailingCommas": true
                  }
                }
              ],
              "json.schemaDownload.enable": false,
              "json.schemaDownload.trustedDomains": {
                "https://biomejs.dev": true,
                "https://developer.microsoft.com/json-schemas/": true,
                "https://dprint.dev": true,
                "https://json-schema.org/": true,
                "https://json.schemastore.org/": true,
                "https://raw.githubusercontent.com/catppuccin/vscode/catppuccin-vsc-v3.19.0/packages/catppuccin-vsc/schemas/colorOverrides.schema.json": true,
                "https://raw.githubusercontent.com/catppuccin/vscode/catppuccin-vsc-v3.19.0/packages/catppuccin-vsc/schemas/customUIColors.schema.json": true,
                "https://raw.githubusercontent.com/DavidAnson/markdownlint/v0.40.0/schema/markdownlint-config-schema.json": true,
                "https://raw.githubusercontent.com/devcontainers/spec/": true,
                "https://raw.githubusercontent.com/microsoft/vscode/": true,
                "https://schemastore.azurewebsites.net/": true,
                "https://www.schemastore.org/": true
              },
              "[markdown]": {
                "editor.defaultFormatter": "DavidAnson.vscode-markdownlint"
              },
              "[nix]": {
                "editor.defaultFormatter": "jnoortheen.nix-ide",
                "editor.formatOnSave": true
              },
              "nix.enableLanguageServer": true,
              "nix.serverPath": "nixd",
              "nix.serverSettings": {
                "nixd": {
                  "formatting": {
                    "command": [
                      "alejandra",
                      "-q",
                      "-"
                    ]
                  }
                }
              },
              "[properties]": {
                "editor.defaultFormatter": "yy0931.gitconfig-lsp"
              },
              "rubyLsp.enableExperimentalFeatures": true,
              "[rust]": {
                "editor.defaultFormatter": "rust-lang.rust-analyzer"
              },
              "rust-analyzer.cargo.features": "all",
              "rust-analyzer.check.command": "clippy",
              "[shellscript]": {
                "editor.defaultFormatter": "mkhl.shfmt"
              },
              "bashIde.explainshellEndpoint": "http://localhost:5000",
              "[sql]": {
                "editor.defaultFormatter": "adpyke.vscode-sql-formatter"
              },
              "[toml]": {
                "editor.defaultFormatter": "tombi-toml.tombi"
              },
              "[typst]": {
                "editor.defaultFormatter": "myriad-dreamin.tinymist"
              },
              "[typst-code]": {
                "editor.defaultFormatter": "myriad-dreamin.tinymist"
              },
              "[yaml]": {
                "editor.defaultFormatter": "bluebrown.yamlfmt"
              },
              "yaml.disableSchemaDetection": [
                "**/.github/workflows/*.yml",
                "**/.github/workflows/*.yaml",
                "**/.gitea/workflows/*.yml",
                "**/.gitea/workflows/*.yaml",
                "**/.forgejo/workflows/*.yml",
                "**/.forgejo/workflows/*.yaml"
              ],
              "zig.zls.enabled": "on"
            }
          '';
        })
      ]
      ++ map (entry:
        entry
        // {
          userSettings = {};
          keybindings = [];
        }) [
        markup.entries.dataFormats
        markup.entries.typst
        nix.entries.nixLsp
        scripting.entries.python
        scripting.entries.nushell
        scripting.entries.ruby
        systems.entries.rust
        systems.entries.shell
        web.entries.tailwind
        web.entries.deno
        web.entries.prettier
        web.entries.browser
      ];
  }
