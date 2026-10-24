_: {
  extensions = [
    "myriad-dreamin.tinymist"
  ];
  settings = {
    #> Language-scoped editor defaults for Typst documents.
    "[typst][typst-code]" = {
      "editor.defaultFormatter" = "myriad-dreamin.tinymist";
      # "editor.inlayHints.enabled" = "off";
      "editor.quickSuggestions".strings = true;
      # "editor.semanticHighlighting.enabled" = true;
      # "editor.tabSize" = 2;
      # "editor.wordWrap" = "on";
    };

    #> Italic-bold the semantic scopes tinymist emits for variable references,
    #> function calls, parameters, interpolations, tags, and keywords.
    "editor.tokenColorCustomizations" = {
      textMateRules = [
        {
          scope = [
            "variable.other.typst"
            "meta.function-call.typst"
            "entity.name.function.typst"
            "variable.parameter.typst"
            "punctuation.definition.variable.typst"
            "meta.interpolation.typst"
            "entity.name.tag.typst"
            "support.function.typst"
            "keyword.other.typst"
          ];
          settings = {
            fontStyle = "italic bold";
          };
        }
      ];
    };

    #> Associate `.typ` files with the `typst` language id.
    "files.associations" = {
      "*.typ" = "typst";
    };

    # ── Tinymist LSP ──────────────────────────────────────────────────────
    "tinymist.compileStatus" = "enable";

    #> Postfix, symbol, and snippet completion behaviour.
    "tinymist.completion.postfix" = true;
    "tinymist.completion.postfixUfcs" = true;
    "tinymist.completion.postfixUfcsLeft" = true;
    "tinymist.completion.postfixUfcsRight" = true;
    "tinymist.completion.symbol" = "step";
    "tinymist.completion.triggerOnSnippetPlaceholders" = false;

    #> Override default word separators on startup.
    #?  - enable: Override the default word separators on startup
    #?  - disable: Do not override the default word separators on startup
    "tinymist.configureDefaultWordSeparator" = "disable";

    #> Conversions between Typst templates and other formats.
    "tinymist.convertExtension" = [];

    #> Handle copy-paste of resources into the editing document.
    #?  - enable: Enable copy-and-paste.
    #?  - disable: Disable copy-and-paste.
    "tinymist.copyAndPaste" = "enable";

    #> Handle drag-and-drop of resources into the editing document.
    #?  - enable: Enable drag-and-drop.
    #?  - disable: Disable drag-and-drop.
    "tinymist.dragAndDrop" = "enable";

    #> When to export PDFs.
    #?  - never: Never export PDFs, run typst manually.
    #?  - onSave: Export PDFs when a file is saved.
    #?  - onType: Export PDFs as you type.
    #?  - onDocumentHasTitle: (Deprecated) Export PDFs when a document has a title.
    "tinymist.exportPdf" = "never";

    #> Export target; affects how the language server completes code.
    #?  - paged: PDF, PNG, and SVG export.
    #?  - html: HTML export.
    #?  - bundle: Bundle export.
    "tinymist.exportTarget" = "paged";

    #> Extra font files/directories for the shared compiler environment.
    "tinymist.fontPaths" = null;

    #> Formatter settings.
    "tinymist.formatterIndentSize" = 2;
    "tinymist.formatterMode" = "typstyle";
    "tinymist.formatterPrintWidth" = 120;
    "tinymist.formatterProseWrap" = "none";

    #> Show inline decorations for package version status.
    "tinymist.inlayHints.packageVersionStatus" = true;

    #> Lint settings.
    "tinymist.lint.enabled" = false;
    #?  - onSave: Perform lint checks on save
    #?  - onType: Perform lint checks on type
    "tinymist.lint.when" = "onSave";

    #> Enable LSP `onEnter` for automatic insertion (e.g. `///` for comments).
    "tinymist.onEnterEvent" = true;

    #> Paste script for resources (Typst expression or path pattern).
    "tinymist.onPaste" = "$root/assets";

    #> Path pattern for Typst artifacts (`$root`/`$dir`/`$name` supported).
    "tinymist.outputPath" = "";

    #> Preview settings.
    "tinymist.preview.cursorIndicator" = false;
    #> Deprecated; use `tinymist.fontPaths`.
    "tinymist.preview.fontPaths" = [];
    "tinymist.preview.invertColors" = "never";
    "tinymist.preview.partialRendering" = true;
    #> Deprecated; the previewed file is always pinned as the entrypoint.
    "tinymist.preview.pinPreviewFile" = false;
    #> When to refresh the preview.
    #?  - onSave: Refresh preview on save
    #?  - onType: Refresh preview on type
    "tinymist.preview.refresh" = "onType";
    #> Scroll sync mode.
    #?  - never: Disable automatic scroll sync
    #?  - onSelectionChangeByMouse: Sync on mouse selection
    #?  - onSelectionChange: Sync on any selection change
    "tinymist.preview.scrollSync" = "onSelectionChangeByMouse";
    #> Ignored; use `tinymist.typstExtraArgs` for `--input`.
    "tinymist.preview.sysInputs" = {};
    #> Deprecated; use `tinymist.systemFonts`.
    "tinymist.preview.systemFonts" = true;

    #> Previewer selection.
    "tinymist.previewer" = "myriad-dreamin.tinymist";

    #> Enable preview features.
    #?  - enable: Enable preview features.
    #?  - disable: Disable preview features.
    "tinymist.previewFeature" = "enable";

    #> Project resolution strategy.
    #?  - singleFile: Each file is its own document (like Markdown).
    #?  - lockDatabase: Track preview/compile history per workspace (like Rust).
    "tinymist.projectResolution" = "singleFile";

    #> Render Typst elements in hover docs.
    #?  - enable: Enable render docs.
    #?  - disable: Disable render docs.
    "tinymist.renderDocs" = "enable";

    #> Typst root for absolute paths.
    "tinymist.rootPath" = null;

    #> Semantic tokens (LSP syntax highlighting).
    #?  - enable: Use semantic tokens
    #?  - disable: Do not use semantic tokens
    "tinymist.semanticTokens" = "enable";

    #> Path to a local tinymist executable; `"tinymist"` looks in PATH.
    "tinymist.serverPath" = null;

    #> How to open exported files.
    "tinymist.showExportFileIn" = null;

    #> Status bar format string. Placeholders: `{compileStatusIcon}`,
    #> `{wordCount}`, `{charCount}`, `{fileName}`. Empty hides the status bar.
    "tinymist.statusBarFormat" = "{compileStatusIcon} {wordCount} [{fileName}]";

    #> Syntax-only mode.
    #?  - auto: Follow future heuristics (currently off).
    #?  - onPowerSaving: Enable in power-saving mode.
    #?  - enable: Always enable.
    #?  - disable: Always disable.
    "tinymist.syntaxOnly" = "auto";

    #> Load system fonts for the shared compiler environment.
    "tinymist.systemFonts" = true;

    #> Trace LSP communication.
    "tinymist.trace.server" = "off";

    #> Prefix newlines after comments with the corresponding prefix.
    "tinymist.typingContinueCommentsOnNewline" = true;

    #> CLI-shaped extra arguments to the Typst compiler.
    "tinymist.typstExtraArgs" = [];
  };
}
