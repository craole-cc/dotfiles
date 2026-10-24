{lix, ...}: let
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.lists.predicates) isIn;
  formatter = "biomejs.biome";
  trustFormatter = name: link:
    optionalAttrs (isIn name formatter)
    {${link} = true;};
in {
  extensions = [
    formatter
    "bradlc.vscode-tailwindcss"
    "denoland.vscode-deno"
    "esbenp.prettier-vscode"
    "phu1237.vs-browser"
  ];

  settings = {
    "[javascript]".editor.defaultFormatter = formatter;
    "[typescript]".editor.defaultFormatter = formatter;
    "[html]".editor.defaultFormatter = formatter;
    "[css]".editor.defaultFormatter = formatter;
    "[scss]".editor.defaultFormatter = formatter;
    "[json]".editor.defaultFormatter = "vscode.json-language-features";
    "[jsonc]".editor.defaultFormatter = "vscode.json-language-features";

    "tailwindCSS.includeLanguages".plaintext = "html";
    "cssvar.files" = [
      "./node_modules/open-props/open-props.min.css"
      "assets/styles/variables.css"
      "style.css"
    ];
    "cssvar.extensions" = ["css" "postcss" "jsx" "tsx"];
    "cssvar.ignore" = [];

    "typescript.inlayHints.parameterNames.enabled" = "all";

    "vs-browser.favourites.list" = {
      "http://127.0.0.1:3000" = "http://127.0.0.1:3000";
      "http://localhost" = "http://localhost";
    };
    "vs-browser.link.enabled" = true;
    "vs-browser.link.openWith" = "ask";
    "vs-browser.localProxyServer.cookieDomainRewrite" = true;
    "vs-browser.localProxyServer.enabled" = true;
    "vs-browser.localProxyServer.forceLocation" = true;
    "vs-browser.reload.autoReloadDurationEnabled" = false;
    "vs-browser.reload.autoReloadDurationTime" = 15000;
    "vs-browser.reload.onSave" = false;
    "vs-browser.url" = "http://127.0.0.1:3000";

    json.schemaDownload = {
      enable = false;
      trustedDomains = mergeSafe [
        (trustFormatter "biome" "https://biomejs.dev")
        (trustFormatter "dprint" "https://dprint.dev")
      ];
    };

    #~@ Semantic  Colour and style for TextMate scopes.
    editor.tokenColorCustomizations.textMateRules = [
      {
        scope = [
          "entity.name.method.js"
          "entity.name.class.js"
          "keyword.control.flow.js"
          "keyword.control.flow.ts"
          "keyword.control.flow.tsx"
          "keyword.control.loop.js"
          "keyword.control.loop.ts"
          "keyword.control.import.js"
          "keyword.control.import.ts"
          "keyword.control.import.tsx"
          "keyword.control.from.js"
          "keyword.control.from.ts"
          "keyword.control.from.tsx"
          "meta.class meta.method.declaration meta.var.expr storage.type.js"
          "source.js constant.other.object.key.js string.unquoted.label.js"
          "storage.type.property.js"
          "storage.type.property.ts"
          "storage.type.property.tsx"
          "tag.decorator.js entity.name.tag.js"
          "tag.decorator.js"
        ];
        settings.fontStyle = "italic";
      }
    ];
  };
}
