{lix, ...}: let
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.attrsets.aggregation) mergeSafe;
  inherit (lix.lists.predicates) isIn;
  formatter = "biomejs.biome";
  trustFormatter = name: link:
    optionalAttrs (isIn name formatter)
    {${link} = true;};
in {
  #TODO:
  extensions = [
    formatter
  ];

  settings = {
    "[javascript]" = {
      editor.defaultFormatter = formatter;
    };
    "[typescript]" = {
      editor.defaultFormatter = formatter;
    };

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
