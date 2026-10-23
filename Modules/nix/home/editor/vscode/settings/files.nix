_: {
  userSettings = {
    "files.autoSave" = "onFocusChange";
    "files.eol" = "\n";
    "files.insertFinalNewline" = true;
    "files.trimFinalNewlines" = true;
    "files.trimTrailingWhitespace" = true;

    "files.associations" = {
      ".bash*" = "shellscript";
      ".dotsrc" = "coffeescript";
      ".editorconfig" = "ini";
      ".env" = "env";
      ".env*" = "dotenv";
      ".sqruff" = "properties";
      "**/*.conf" = "ini";
      "**/conf*/{fuzzel,ghostty,mpv,hyprland}/*" = "ini";
      "**/conf*/{raffi}/*" = "yaml";
      "*.Xresources" = "xdefaults";
      "*envrc" = "shellscript";
      "*gitignore" = "ignore";
      "*ignore" = "ignore";
      "*shellcheckrc" = "shellscript";
      "editorconfig" = "ini";
      "flake.lock" = "json";
      "i3/*.conf" = "i3";
      "i3/config" = "i3";
      "lesskey" = "lesskey";
      "mise.lock" = "toml";
      "polybar/*.conf" = "ini";
      "polybar/config" = "ini";
      "*.bash" = "shellscript";
      "*.css" = "css";
      "*.erb" = "ruby";
      "*.ft" = "rust";
      "*.gs" = "javascript";
      "*.init" = "shellscript";
      "*.nix" = "nix";
      "*.nu" = "nushell";
      "*.rs" = "rust";
      "*.sh" = "shellscript";
      "*.typ" = "typst";
      "Gemfile" = "ruby";
      "*.bbmodel" = "json";
      "*.ejs" = "html";
      "*.emu" = "html";
      "*.hbs" = "html";
      "*.layout" = "json";
      "*.log" = "log";
      "*.rasi" = "css";
      "*.sublime-snippet" = "xml";
      "LICENSE" = "txt";
      "LICENSE-MIT" = "txt";
      "README" = "markdown";
    };

    "files.exclude" = {
      "**/.DS_Store" = false;
      "**/.git" = false;
      "**/.hg" = false;
      "**/.svn" = false;
      "**/Thumbs.db" = false;
    };

    "files.watcherExclude" = {
      "**/.local/* *" = true;
      "**/.vscode-server-insiders/* *" = true;
      "**/* cache/* *" = true;
      "**/.trunk/*actions/" = true;
      "**/.trunk/*logs/" = true;
      "**/.trunk/*notifications/" = true;
      "**/.trunk/*out/" = true;
      "**/.trunk/*plugins/" = true;
    };
  };
}
