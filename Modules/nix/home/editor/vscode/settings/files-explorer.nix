{
  mkGroup,
  mkEntry,
  ...
} @ args: let
  productivity = import ./entries/productivity.nix args;
in
  mkGroup {
    name = "files-explorer";
    description = "Files & Explorer";
    default = true;
    features =
      [
        (mkEntry {
          userSettings = builtins.fromJSON ''
            {
              "files.autoSave": "onFocusChange",
              "files.insertFinalNewline": true,
              "files.trimFinalNewlines": true,
              "files.trimTrailingWhitespace": true,
              "explorer.compactFolders": false,
              "explorer.excludeGitIgnore": false,
              "files.exclude": {
                "**/.DS_Store": false,
                "**/.git": false,
                "**/.hg": false,
                "**/.svn": false,
                "**/Thumbs.db": false
              },
              "files.watcherExclude": {
                "**/.local/* *": true,
                "**/.vscode-server-insiders/* *": true,
                "**/* cache/* *": true,
                "**/.trunk/*actions/": true,
                "**/.trunk/*logs/": true,
                "**/.trunk/*notifications/": true,
                "**/.trunk/*out/": true,
                "**/.trunk/*plugins/": true
              },
              "files.associations": {
                ".bash*": "shellscript",
                ".dotsrc": "coffeescript",
                ".editorconfig": "ini",
                ".env": "env",
                ".env*": "dotenv",
                ".sqruff": "properties",
                "**/*.conf": "ini",
                "**/conf*/{fuzzel,ghostty,mpv,hyprland}/*": "ini",
                "**/conf*/{raffi}/*": "yaml",
                "*.Xresources": "xdefaults",
                "*envrc": "shellscript",
                "*gitignore": "ignore",
                "*ignore": "ignore",
                "*shellcheckrc": "shellscript",
                "editorconfig": "ini",
                "flake.lock": "json",
                "i3/*.conf": "i3",
                "i3/config": "i3",
                "lesskey": "lesskey",
                "mise.lock": "toml",
                "polybar/*.conf": "ini",
                "polybar/config": "ini",
                "*.bash": "shellscript",
                "*.css": "css",
                "*.erb": "ruby",
                "*.ft": "rust",
                "*.gs": "javascript",
                "*.init": "shellscript",
                "*.nix": "nix",
                "*.nu": "nushell",
                "*.rs": "rust",
                "*.sh": "shellscript",
                "*.typ": "typst",
                "Gemfile": "ruby",
                "*.bbmodel": "json",
                "*.ejs": "html",
                "*.emu": "html",
                "*.hbs": "html",
                "*.layout": "json",
                "*.log": "log",
                "*.rasi": "css",
                "*.sublime-snippet": "xml",
                "LICENSE": "txt",
                "LICENSE-MIT": "txt",
                "README": "markdown"
              },
              "workbench.editorAssociations": {
                "*.copilotmd": "vscode.markdown.preview.editor",
                "{git,gitlens,chat-editing-snapshot-text-model,copilot,git-graph,git-graph-3}:/**/*.qrc": "default",
                "{git,gitlens,chat-editing-snapshot-text-model,copilot,git-graph,git-graph-3}:/**/*.ui": "default",
                "*.db": "default",
                "*.pdf": "pdf.view",
                "*.qrc": "qt-core.qrcEditor",
                "*.tsv": "csvViewer.csvEditor",
                "*.xlsx": "csvViewer.csvEditor"
              }
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
        productivity.entries.files
        productivity.entries.viewers
      ];
  }
