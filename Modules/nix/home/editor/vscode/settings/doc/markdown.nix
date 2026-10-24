_: {
  extensions = [
    #? Markdown slides (Marp)
    "marp-team.marp-vscode"
    #? Fast Rust-based markdown linter
    "rvben.rumdl"
    #? Markdown editing helpers (TOC, table formatter, …)
    "yzhang.markdown-all-in-one"
  ];

  settings = {
    #~@ Language-scoped overrides
    #> Built-in: markdownlint is the formatter for `.md`.
    #! overridden (default formatter: none)
    "[markdown]" = {
      "editor.defaultFormatter" = "rvben.rumdl";
    };

    #~@ markdown (built-in)
    #> Typographer-style quotes and dashes in preview.
    #! overridden (default: false)
    "markdown.preview.typographer" = true;
    #> Update links when files move.
    #?  - never | prompt | always
    #! overridden (default: "never")
    "markdown.updateLinksOnFileMove.enabled" = "always";
    #> Validate links in Markdown files.
    #! overridden (default: false)
    "markdown.validate.enabled" = true;

    #~@ Marp
    #> Enable raw HTML in Markdown slides (needed for most themes).
    #! overridden (default: false)
    "markdown.marp.enableHtml" = true;
    #> Default export format.
    #?  - pdf | html | pptx | png | jpeg
    #! overridden (default: "pdf")
    "markdown.marp.exportType" = "html";
    #> Add PDF note annotations from HTML comments.
    #! overridden (default: false)
    "markdown.marp.pdf.noteAnnotations" = true;
    #> Where PDF outlines are generated from.
    #?  - none | headings | slides | both
    #! overridden (default: "none")
    "markdown.marp.pdf.outlines" = "both";
    #> Resolve relative paths strictly during export.
    #! overridden (default: false)
    "markdown.marp.strictPathResolutionDuringExport" = true;

    #~@ markdown-pdf
    #> Enable `<br>` rendering for line breaks.
    #! overridden (default: false)
    "markdown-pdf.breaks" = true;
    #> Auto-download Chromium if no system browser is available.
    "markdown-pdf.chromium.autoDownload" = true;
    #> PNG/JPEG clip region.
    "markdown-pdf.clip.x" = "";
    "markdown-pdf.clip.y" = "";
    "markdown-pdf.clip.width" = "";
    "markdown-pdf.clip.height" = "";
    #> Auto-export on save.
    "markdown-pdf.convertOnSave" = false;
    #> Files to skip for `convertOnSave`.
    "markdown-pdf.convertOnSaveExclude" = [];
    #> Print header/footer.
    #! overridden (default: true)
    "markdown-pdf.displayHeaderFooter" = false;
    #> Emoji rendering.
    "markdown-pdf.emoji" = true;
    #> Path to Chromium/Chrome. Empty = bundled.
    "markdown-pdf.executablePath" = "";
    #> Footer HTML template (only when displayHeaderFooter = true).
    "markdown-pdf.footerTemplate" = "<div style=\"font-size: 9px; margin: 0 auto;\"> <span class='pageNumber'></span> / <span class='totalPages'></span></div>";
    #> Paper format.
    #?  - Letter | Legal | Tabloid | Ledger | A0..A6
    #! overridden (default: "A4")
    "markdown-pdf.format" = "Letter";
    #> Header HTML template (only when displayHeaderFooter = true).
    "markdown-pdf.headerTemplate" = "<div style=\"font-size: 9px; margin-left: 1cm;\"> <span class='title'></span></div> <div style=\"font-size: 9px; margin-left: auto; margin-right: 1cm; \">%%ISO-DATE%%</div>";
    #> Paper height (overrides `format` when set). Units: mm, cm, in, px.
    "markdown-pdf.height" = "";
    #> Syntax highlighting.
    "markdown-pdf.highlight" = true;
    #> highlight.js stylesheet name. Empty = theme default.
    "markdown-pdf.highlightStyle" = "";
    #> Include VS Code's built-in Markdown styles.
    "markdown-pdf.includeDefaultStyles" = true;
    #> Page margins (mm, cm, in, px).
    "markdown-pdf.margin.top" = "1.5cm";
    "markdown-pdf.margin.bottom" = "1cm";
    "markdown-pdf.margin.left" = "1cm";
    "markdown-pdf.margin.right" = "1cm";
    #> markdown-it-include support.
    "markdown-pdf.markdown-it-include.enable" = true;
    #> Math rendering (KaTeX). Matches the built-in Markdown preview.
    "markdown-pdf.math.enabled" = true;
    #> KaTeX macros.
    "markdown-pdf.math.katex.macros" = {};
    #> Mermaid renderer URL.
    "markdown-pdf.mermaidServer" = "https://unpkg.com/mermaid/dist/mermaid.min.js";
    #> Transparent background for PNG/JPEG.
    "markdown-pdf.omitBackground" = false;
    #> Orientation.
    #?  - portrait | landscape
    "markdown-pdf.orientation" = "portrait";
    #> Output directory (relative to workspace, or absolute).
    "markdown-pdf.outputDirectory" = "";
    #> Resolve `outputDirectory` relative to the file.
    "markdown-pdf.outputDirectoryRelativePathFile" = false;
    #> Page ranges for PDF (e.g. "1-5, 8, 11-13"). Empty = all.
    "markdown-pdf.pageRanges" = "";
    #> PlantUML delimiters.
    "markdown-pdf.plantumlOpenMarker" = "@startuml";
    "markdown-pdf.plantumlCloseMarker" = "@enduml";
    #> PlantUML server.
    "markdown-pdf.plantumlServer" = "http://www.plantuml.com/plantuml";
    #> Print background graphics.
    "markdown-pdf.printBackground" = true;
    #> JPEG quality (0–100).
    "markdown-pdf.quality" = 100;
    #> HTML sanitization.
    #?  - gfm:              Strip dangerous tags (script, iframe, style, …)
    #?  - gfm-allow-style:  Keep <style> for layout customization
    #?  - none:             No sanitization (legacy, unsafe)
    "markdown-pdf.sanitize" = "gfm";
    #> Page render scale.
    "markdown-pdf.scale" = 1;
    #> Status bar message timeout (ms).
    "markdown-pdf.StatusbarMessageTimeout" = 10000;
    #> Custom stylesheets (absolute paths, `\` must be escaped as `\\`).
    "markdown-pdf.styles" = [];
    #> Resolve styles relative to the file.
    "markdown-pdf.stylesRelativePathFile" = false;
    #> Output formats (any combination).
    #?  - pdf | html | png | jpeg
    "markdown-pdf.type" = ["pdf"];
    #> Paper width (overrides `format` when set). Units: mm, cm, in, px.
    "markdown-pdf.width" = "";

    #~@ markdown-all-in-one
    #> Bold marker: `**` or `__`.
    "markdown.extension.bold.indicator" = "**";
    #> Enable auto-completion.
    "markdown.extension.completion.enabled" = false;
    #> Respect VS Code `search.exclude` in completions.
    "markdown.extension.completion.respectVscodeSearchExclude" = true;
    #> Root folder for path auto-completion.
    "markdown.extension.completion.root" = "";
    #> Extra supported languages (e.g. rmd, quarto).
    "markdown.extension.extraLangIds" = [];
    #> Italic marker: `*` or `_`.
    "markdown.extension.italic.indicator" = "*";
    #> KaTeX macros.
    "markdown.extension.katex.macros" = {};
    #> List indentation scheme.
    #?  - adaptive: Align sublist content with parent's content
    #?  - inherit: Use the document's configured tab size
    "markdown.extension.list.indentationSize" = "adaptive";
    #> Candidate list markers (cycled by "Toggle list").
    "markdown.extension.list.toggle.candidate-markers" = ["-" "*" "+" "1." "1)"];
    #> Basic math support via KaTeX.
    "markdown.extension.math.enabled" = true;
    #> Auto renumber ordered list markers.
    "markdown.extension.orderedList.autoRenumber" = true;
    #> Ordered list marker style.
    #?  - one:     Always `1.`
    #?  - ordered: Increasing numbers
    "markdown.extension.orderedList.marker" = "ordered";
    #> Auto-open preview to the side.
    "markdown.extension.preview.autoShowPreviewToSide" = false;
    #> Convert image paths to absolute when printing.
    "markdown.extension.print.absoluteImgPath" = true;
    #> Inline images as base64 when printing.
    "markdown.extension.print.imgToBase64" = false;
    #> Include VS Code's Markdown styles when printing.
    "markdown.extension.print.includeVscodeStylesheets" = true;
    #> Print to HTML on save.
    "markdown.extension.print.onFileSave" = false;
    #> Print to bare HTML (no stylesheets).
    "markdown.extension.print.pureHtml" = false;
    #> Theme for exported HTML (code blocks only).
    "markdown.extension.print.theme" = "light";
    #> Validate URLs when printing.
    "markdown.extension.print.validateUrls" = true;
    #> Show formatting buttons on the editor toolbar.
    "markdown.extension.showActionButtons" = false;
    #> Skip syntax decorations above this size (bytes).
    "markdown.extension.syntax.decorationFileSizeLimit" = 50000;
    #> Deprecated — use `theming.decoration.renderCodeSpan`.
    "markdown.extension.syntax.decorations" = null;
    #> Experimental plain theme.
    "markdown.extension.syntax.plainTheme" = false;
    #> No padding on the table delimiter row.
    "markdown.extension.tableFormatter.delimiterRowNoPadding" = false;
    #> GFM table formatter.
    "markdown.extension.tableFormatter.enabled" = true;
    #> Normalize table indentation to tab-size multiples.
    "markdown.extension.tableFormatter.normalizeIndentation" = false;
    #> Border around code spans.
    "markdown.extension.theming.decoration.renderCodeSpan" = true;
    #> (Experimental) Decorate hard line breaks.
    "markdown.extension.theming.decoration.renderHardLineBreak" = false;
    #> (Experimental) Decorate links.
    "markdown.extension.theming.decoration.renderLink" = false;
    #> (Experimental) Decorate paragraphs.
    "markdown.extension.theming.decoration.renderParagraph" = false;
    #> Strikethrough rendering.
    "markdown.extension.theming.decoration.renderStrikethrough" = true;
    #> Shade trailing whitespace.
    "markdown.extension.theming.decoration.renderTrailingSpace" = false;
    #> TOC heading levels (`x..y`).
    "markdown.extension.toc.levels" = "1..6";
    #> Per-file headings to omit from TOC.
    "markdown.extension.toc.omittedFromToc" = {};
    #> Use ordered list for TOC.
    "markdown.extension.toc.orderedList" = false;
    #> Plain-text TOC (no links).
    "markdown.extension.toc.plaintext" = false;
    #> Heading-ID slugify mode.
    #?  - github | azureDevops | bitbucket-cloud | gitea | gitlab | vscode | zola
    "markdown.extension.toc.slugifyMode" = "github";
    #> Unordered-list marker for TOC (`-`, `*`, `+`).
    "markdown.extension.toc.unorderedList.marker" = "-";
    #> Auto-update TOC on save.
    "markdown.extension.toc.updateOnSave" = true;

    #~@ markdownlint
    #> Which files to lint.
    #?  - allFiles | workspace | project | none
    "markdownlint.appliesTo" = "allFiles";
    #> Deprecated — use a `.markdownlint.*` config file.
    "markdownlint.config" = {};
    #> Path to a config file (`.markdownlint.json` / `.yaml` / …).
    "markdownlint.configFile" = null;
    #> JSON Pointer into the config file.
    "markdownlint.configPointer" = null;
    #> Deprecated — use a config file.
    "markdownlint.customRules" = [];
    #> Focus mode (hide diagnostics on the current line).
    "markdownlint.focusMode" = false;
    #> Glob patterns for the `lintWorkspace` command.
    "markdownlint.lintWorkspaceGlobs" = [
      "**/*.{md,mkd,mdwn,mdown,markdown,markdn,mdtxt,mdtext,workbook}"
      "!**/*.code-search"
      "!**/bower_components"
      "!**/node_modules"
      "!**/.git"
      "!**/vendor"
    ];
    #> When to lint.
    #?  - onType | onSave
    "markdownlint.run" = "onType";
    #> Severity mapping for `error` diagnostics.
    #?  - Error | Warning | Information | Hint
    "markdownlint.severityForError" = "Warning";
    #> Severity mapping for `warning` diagnostics.
    #?  - Error | Warning | Information | Hint
    "markdownlint.severityForWarning" = "Information";

    #~@ rumdl
    #> Path to a rumdl config file. Empty = default config discovery.
    "rumdl.configPath" = "";
    #> Deduplicate diagnostics (useful when multiple linters are active).
    "rumdl.diagnostics.deduplicate" = true;
    #> Enable rumdl linting.
    "rumdl.enable" = true;
    #> Auto-fix on save. For finer control, use `editor.codeActionsOnSave`.
    "rumdl.fixOnSave" = true;
    #> Content roots for absolute link completion (paths starting with `/`).
    #? Empty = workspace folders.
    "rumdl.linkCompletions.contentRoots" = [];
    #> Provide completions inside markdown link targets.
    "rumdl.linkCompletions.enable" = true;
    #> Hover, go-to-def, find-refs, rename for markdown links.
    "rumdl.linkNavigation.enable" = true;
    #> When to lint.
    #?  - onType | onSave
    "rumdl.lint.run" = "onType";
    #> Rules to disable.
    "rumdl.rules.disable" = [];
    #> Rules to enable (if set, only these run).
    "rumdl.rules.enable" = [];
    #> Server log level (Output → rumdl).
    "rumdl.server.logLevel" = "info";
    #> Path to rumdl binary. Empty = auto-detect (.venv → node_modules → PATH → bundled).
    "rumdl.server.path" = "";
    #> LSP trace.
    #?  - off | messages | verbose
    "rumdl.trace.server" = "off";
  };
}
