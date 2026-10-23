{
  mkGroup,
  mkEntry,
  ...
} @ args: let
  markup = import ./entries/markup.nix args;
in
  mkGroup {
    name = "markdown-docs";
    description = "Markdown & Docs";
    default = true;
    features =
      [
        (mkEntry {
          userSettings = builtins.fromJSON ''
            {
              "markdown.preview.typographer": true,
              "markdown.updateLinksOnFileMove.enabled": "always",
              "markdown.validate.enabled": true,
              "markdown.marp.enableHtml": true,
              "markdown.marp.exportType": "html",
              "markdown.marp.pdf.noteAnnotations": true,
              "markdown.marp.pdf.outlines": "both",
              "markdown.marp.strictPathResolutionDuringExport": true,
              "markdown-pdf.breaks": true,
              "markdown-pdf.displayHeaderFooter": false,
              "markdown-pdf.format": "Letter"
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
        markup.entries.markdown
      ];
  }
