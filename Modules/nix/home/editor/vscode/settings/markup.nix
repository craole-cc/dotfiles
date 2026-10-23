{
  inputs,
  mkMerge,
  flatten,
  mkVSCodeFeature,
  mkVSCodeSubFeature,
  pkgs,
  ...
}: let
  markdown = mkVSCodeSubFeature {
    enabled = true;
    extensions = [
      #? Markdown linter
      "davidanson.vscode-markdownlint"
      #? Markdown shortcuts, TOC, preview
      "yzhang.markdown-all-in-one"
      #? Export markdown to PDF
      "yzane.markdown-pdf"
      #? CSV column colorizer
      # "mechatroner.rainbow-csv"
      #? Mermaid diagram preview in markdown
      # "bierner.markdown-mermaid"
      #? GitHub-flavored markdown preview
      "bierner.github-markdown-preview"
    ];
    userSettings = {
      "[markdown]"."editor.defaultFormatter" = "DavidAnson.vscode-markdownlint";
      "markdown.updateLinksOnFileMove.enabled" = "always";
      "markdown.validate.enabled" = true;
      "markdown.preview.typographer" = true;
      "markdown-pdf.breaks" = true;
      "markdown-pdf.displayHeaderFooter" = false;
      "markdown-pdf.format" = "Letter";
      "markdown.marp.enableHtml" = true;
      "markdown.marp.pdf.noteAnnotations" = true;
      "markdown.marp.pdf.outlines" = "both";
      "markdown.marp.exportType" = "html";
      "markdown.marp.strictPathResolutionDuringExport" = true;
    };
  };

  dataFormats = mkVSCodeSubFeature {
    enabled = true;
    extensions = [
      #? YAML LSP and validation
      "redhat.vscode-yaml"
      #? YAML formatter
      "bluebrown.yamlfmt"
      #? TOML LSP and formatter
      "tombi-toml.tombi"
      #? SQL formatter
      "adpyke.vscode-sql-formatter"
      #? INI/properties formatter
      "lkrms.inifmt"
      #? KDL document language support
      "kdl-org.kdl"
    ];
    userSettings = {
      "[toml]"."editor.defaultFormatter" = "tombi-toml.tombi";
      "[sql]"."editor.defaultFormatter" = "adpyke.vscode-sql-formatter";
      "[ini]"."editor.defaultFormatter" = "lkrms.inifmt";
      "[properties]"."editor.defaultFormatter" = "yy0931.gitconfig-lsp";
      "[yaml]"."editor.defaultFormatter" = "bluebrown.yamlfmt";
      "[github-actions-workflow]"."editor.defaultFormatter" = "redhat.vscode-yaml";
      "redhat.telemetry.enabled" = false;
      "yaml.disableSchemaDetection" = [
        "**/.github/workflows/*.yml"
        "**/.github/workflows/*.yaml"
        "**/.gitea/workflows/*.yml"
        "**/.gitea/workflows/*.yaml"
        "**/.forgejo/workflows/*.yml"
        "**/.forgejo/workflows/*.yaml"
      ];
      "json.schemaDownload.enable" = false;
      "json.schemaDownload.trustedDomains" = {
        "https://biomejs.dev" = true;
        "https://developer.microsoft.com/json-schemas/" = true;
        "https://dprint.dev" = true;
        "https://json-schema.org/" = true;
        "https://json.schemastore.org/" = true;
        "https://raw.githubusercontent.com/catppuccin/vscode/catppuccin-vsc-v3.19.0/packages/catppuccin-vsc/schemas/colorOverrides.schema.json" = true;
        "https://raw.githubusercontent.com/catppuccin/vscode/catppuccin-vsc-v3.19.0/packages/catppuccin-vsc/schemas/customUIColors.schema.json" = true;
        "https://raw.githubusercontent.com/DavidAnson/markdownlint/v0.40.0/schema/markdownlint-config-schema.json" = true;
        "https://raw.githubusercontent.com/devcontainers/spec/" = true;
        "https://raw.githubusercontent.com/microsoft/vscode/" = true;
        "https://schemastore.azurewebsites.net/" = true;
        "https://www.schemastore.org/" = true;
      };
      "json.schemas" = [
        {
          "fileMatch" = ["**/*.json" "**/*.jsonc"];
          "schema"."allowTrailingCommas" = true;
        }
      ];
    };
  };

  typst = mkVSCodeSubFeature {
    enabled = true;
    extensions = [
      #? Typst LSP and preview
      "myriad-dreamin.tinymist"
    ];
    userSettings = {
      "[typst]"."editor.defaultFormatter" = "myriad-dreamin.tinymist";
      "[typst-code]"."editor.defaultFormatter" = "myriad-dreamin.tinymist";
    };
  };

  tooling = mkVSCodeSubFeature {
    enabled = false;
    extensions = [
      #? Justfile syntax highlighting
      "nefrob.vscode-just-syntax"
      #? mise version manager integration
      "hverlin.mise-vscode"
      #? log file syntax highlighting
      "emilast.logfilehighlighter"
    ];
  };
in {
  name = "markup";
  description = "Markdown, TOML, YAML, config format extensions";
  default = true;
  feature = enabled:
    mkVSCodeFeature {
      inherit enabled pkgs inputs;
      extensions = flatten [
        markdown.extensions
        dataFormats.extensions
        typst.extensions
        tooling.extensions
      ];
      userSettings = mkMerge [
        (markdown.userSettings or {})
        (dataFormats.userSettings or {})
        (typst.userSettings or {})
        (tooling.userSettings or {})
      ];
      keybindings = flatten (map (feature: feature.keybindings or []) [markdown dataFormats typst tooling]);
    };
}
