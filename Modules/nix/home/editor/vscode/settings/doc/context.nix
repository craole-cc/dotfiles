_: {
  extensions = [
    #? Cherry-pick workspace files as XML payloads for LLM prompts.
    "airizom.context-craft"
    #? Scans folders to generate file data or a tree structure.
    "shinazbinshajahan.fileinator"
    #? Dump selected files/folders to Markdown, or load them back.
    "NixFractal.md-file-dumper"
  ];

  settings = {
    #~@ context-craft
    #> Excludes scoped to "Copy Content" only. Merged with global excludes.
    "copyContext.copyContent.excludeGlobs" = [];
    #> Includes scoped to "Copy Content" only. Merged with global includes.
    "copyContext.copyContent.includeGlobs" = [];

    #> Excludes scoped to "Copy Tree" only. Merged with global excludes.
    "copyContext.copyTree.excludeGlobs" = [];
    #> Includes scoped to "Copy Tree" only. Merged with global includes.
    "copyContext.copyTree.includeGlobs" = [];

    #> Global excludes applied to all commands. Highest priority;
    #> command-specific excludes are merged on top.
    "copyContext.excludeGlobs" = [];
    #> Global includes applied to all commands. Command-specific
    #> includes are merged on top.
    "copyContext.includeGlobs" = [];

    #> Maximum total size (bytes) of all copied file contents. Prevents
    #> dumping very large files into your prompt.
    "copyContext.maxContentSize" = 500000;

    #> Skip files matching the project's `.gitignore` (opt-in).
    #! overridden (default: false)
    "copyContext.respectGitIgnore" = true;

    #> Skip files/folders hidden in the VS Code Explorer (respects
    #> `files.exclude`).
    "copyContext.respectVSCodeExplorerExclude" = true;

    #> Additional file extensions to treat as text (without the dot).
    #? Useful for custom or newer file types not recognised by default.
    #? Example: `["zmodel", "prisma"]`
    "copyContext.additionalTextExtensions" = [];

    #> Include emojis in the output (📁 for folders, 📄 for files).
    #! overridden (default: false)
    "copyContext.includeEmojis" = false;

    #> Place the file path above the fenced code block instead of inside
    #? it. Applies to Copy Content & Copy Selection only; Copy Tree
    #? always keeps paths inside.
    "copyContext.pathOutsideCodeBlock" = false;

    #~@ fileinator
    #> Folder paths (relative to workspace root) to ignore in scans.
    "fileinator.ignoredFolders" = [];

    #~@ md-file-dumper
    #? Namespaced `mdFileDumper.*`. Flat registration — do not nest.

    #> Extensions to always treat as binary (regardless of content).
    "mdFileDumper.binary.forceAsBin" = [];
    #> Extensions to block from binary handling.
    "mdFileDumper.binary.blockedTypes" = [];
    #> How binary files are encoded in the dump.
    #?  - base64_zip: base64 + zip payload
    #?  - base64:     base64 only
    #?  - skip:       omit binary files entirely
    "mdFileDumper.binary.format" = "base64_zip";
    #> Maximum binary file size to include (KB).
    "mdFileDumper.binary.maxSizeKb" = 1024;
    #> How to handle binary files during dump.
    #?  - allow:     include (with encoding per `format`)
    #?  - forbid:    exclude binary files
    #?  - ask:       prompt
    "mdFileDumper.binary.mode" = "allow";

    #> Allowed file extensions for the dump (empty = all).
    "mdFileDumper.files.allowedTypes" = [];
    #> Blocked file extensions for the dump (glob patterns supported).
    #?  Empty = none.
    "mdFileDumper.files.blockedTypes" = [
      "**/*.{pyc,pyo,pyd,swp,swo,lock,bak,tmp,temp}"
      "**/.git/**"
      "**/.venv/**"
      "**/.env/**"
      "**/node_modules/**"
      "**/__pycache__/**"
      "**/.pytest_cache/**"
      "**/.mypy_cache/**"
      "**/.ruff_cache/**"
      "**/.cache/**"
      "**/Thumbs.db"
    ];

    #> Prefix used for file headers in the dump.
    "mdFileDumper.prefix" = "##";
    #> Show "Export/Import to File" command in the menu.
    "mdFileDumper.showImportExportToFile" = false;
  };
}
