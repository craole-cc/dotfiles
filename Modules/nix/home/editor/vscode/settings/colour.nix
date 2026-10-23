{
  mkGroup,
  mkEntry,
  fromJSON,
  ...
}:
mkGroup {
  name = "themes";
  description = "Themes";
  default = true;
  features = [
    (mkEntry {
      extensions = ["catppuccin.catppuccin-vsc"];
      userSettings = fromJSON ''
        {
          "workbench.preferredDarkColorTheme": "Catppuccin Frappé",
          "workbench.preferredLightColorTheme": "Catppuccin Latte",
          "editor.semanticHighlighting.enabled": true
          "editor.semanticTokenColorCustomizations": {
            "rules": {
              "*.static": {
                "italic": true
              },
              "interface": {
                "italic": true
              },
              "keyword": {
                "italic": true
              },
              "selfParameter": {
                "italic": true
              }
            }
          },
          "editor.tokenColorCustomizations": {
            "[*Light*]": {
              "textMateRules": [
                {
                  "scope": "ref.matchtext",
                  "settings": {
                    "foreground": "#000"
                  }
                }
              ]
            },
            "[*Dark*]": {
              "textMateRules": [
                {
                  "scope": "ref.matchtext",
                  "settings": {
                    "foreground": "#fff"
                  }
                }
              ]
            },
            "textMateRules": [
              {
                "scope": [
                  "variable.other.typst",
                  "meta.function-call.typst",
                  "entity.name.function.typst",
                  "variable.parameter.typst",
                  "punctuation.definition.variable.typst",
                  "meta.interpolation.typst",
                  "entity.name.tag.typst",
                  "support.function.typst",
                  "keyword.other.typst"
                ],
                "settings": {
                  "fontStyle": "italic bold"
                }
              },
              {
                "scope": [
                  "comment",
                  "emphasis",
                  "entity.name.method.js",
                  "entity.name.class.js",
                  "entity.name.tag.doctype",
                  "entity.other.attribute-name",
                  "entity.other.attribute-name.tag.jade",
                  "entity.other.attribute-name.tag.pug",
                  "keyword",
                  "keyword.control",
                  "keyword.operator.comparison",
                  "keyword.control.flow.js",
                  "keyword.control.flow.ts",
                  "keyword.control.flow.tsx",
                  "keyword.control.ruby",
                  "keyword.control.module.ruby",
                  "keyword.control.class.ruby",
                  "keyword.control.def.ruby",
                  "keyword.control.loop.js",
                  "keyword.control.loop.ts",
                  "keyword.control.import.js",
                  "keyword.control.import.ts",
                  "keyword.control.import.tsx",
                  "keyword.control.from.js",
                  "keyword.control.from.ts",
                  "keyword.control.from.tsx",
                  "keyword.operator.expression.delete",
                  "keyword.operator.new",
                  "keyword.operator.expression",
                  "keyword.operator.cast",
                  "keyword.operator.relational",
                  "keyword.operator.sizeof",
                  "keyword.operator.logical.python",
                  "italic",
                  "markup.changed",
                  "markup.deleted.diff",
                  "markup.italic",
                  "markup.italic.markdown",
                  "markup.quote",
                  "markup.quote.markdown",
                  "meta.decorator punctuation.decorator",
                  "meta.delimiter.period",
                  "meta.diff.header.git",
                  "meta.diff.header.from-file",
                  "meta.diff.header.to-file",
                  "markup.inserted.diff",
                  "meta.class meta.method.declaration meta.var.expr storage.type.js",
                  "meta.tag.sgml.doctype",
                  "meta.selector",
                  "punctuation.accessor",
                  "punctuation.definition.comment",
                  "punctuation.definition.template-expression.begin",
                  "punctuation.definition.template-expression.end",
                  "punctuation.section.embedded",
                  "quote",
                  "source.js constant.other.object.key.js string.unquoted.label.js",
                  "source.go keyword.package.go",
                  "source.go keyword.import.go",
                  "source.go keyword.function.go",
                  "source.go keyword.type.go",
                  "source.go keyword.struct.go",
                  "source.go keyword.interface.go",
                  "source.go keyword.const.go",
                  "source.go keyword.var.go",
                  "source.go keyword.map.go",
                  "source.go keyword.channel.go",
                  "source.go keyword.control.go",
                  "storage",
                  "storage.type",
                  "storage.modifier",
                  "storage.type.property.js",
                  "storage.type.property.ts",
                  "storage.type.property.tsx",
                  "tag.decorator.js entity.name.tag.js",
                  "tag.decorator.js",
                  "text.html.basic entity.other.attribute-name.html",
                  "text.html.basic entity.other.attribute-name",
                  "variable.language",
                  "variable.other.object.property"
                ],
                "settings": {
                  "fontStyle": "italic"
                }
              }
            ]
          },
          "workbench.colorCustomizations": {}
        }
      '';
    })
  ];
}
