{
  fonts,
  mkEntry,
  mkGroup,
  ...
}: let
  themes = mkEntry {
    enabled = false;
    extensions = [
      #? Catppuccin color theme
      "catppuccin.catppuccin-vsc"
      #? Bluloco dark theme
      # "uloco.theme-bluloco-dark"
      #? Bluloco light theme
      # "uloco.theme-bluloco-light"
    ];
    userSettings = {
      # "workbench.colorTheme" = "Dynamic Base16 DankShell";
      "workbench.preferredDarkColorTheme" = "Catppuccin Frappé";
      "workbench.preferredLightColorTheme" = "Catppuccin Latte";
    };
  };

  icons = mkEntry {
    enabled = true;
    extensions = [
      #? Material file/folder icons
      "pkief.material-icon-theme"
      #? Material UI chrome icons
      "pkief.material-product-icons"
      #? Alternative product icon theme
      "elanandkumar.el-vsc-product-icon-theme"
    ];
    userSettings = {
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.productIconTheme" = "el-vsc-v1-icons";
      "material-icon-theme.activeIconPack" = "react";
      "material-icon-theme.hidesExplorerArrows" = true;
      "material-icon-theme.files.color" = "#e8ddd8";
      "material-icon-theme.folders.color" = "#81c8be";
      "material-icon-theme.files.associations" = {
        ".editorconfig" = "editorconfig";
        ".mise.toml" = "jenkins";
        ".treefmt.toml" = "taze";
        "editorconfig" = "editorconfig";
        "mise.toml" = "jenkins";
        "treefmt.toml" = "taze";
        "treefmt/config.toml" = "taze";
      };
      "material-icon-theme.files.customClones" = [
        {
          "name" = "rust-entrypoint";
          "base" = "rstack";
          "color" = "orange-800";
          "lightColor" = "orange-800";
          "fileNames" = [
            ".cargo/config.toml"
            ".rust-analyzer.toml"
            ".rustfmt.toml"
            "Cargo.toml"
            "lib.rs"
            "main.rs"
            "mod.rs"
            "rust-analyzer.toml"
            "rust-toolchain"
            "rust-toolchain.toml"
            "rustfmt.toml"
          ];
        }
        {
          "name" = "nix-entrypoint";
          "base" = "nix";
          "color" = "cyan-300";
          "lightColor" = "cyan-600";
          "fileNames" = [
            "configuration.nix"
            "default.nix"
            "flake.nix"
            "shell.nix"
          ];
        }
        {
          "name" = "dotenv";
          "base" = "key";
          "color" = "amber-300";
          "lightColor" = "amber-600";
          "fileNames" = [
            ".env"
            ".envrc"
            "env"
            "envrc"
          ];
        }
        {
          "name" = "sublime-text";
          "base" = "sublime";
          "color" = "amber-300";
          "lightColor" = "amber-600";
          "fileNames" = [
            ".sublime"
            "Preferences.sublime-settings"
            "sublime"
            "sublime-settings"
          ];
        }
        {
          "name" = "markdownlinter";
          "base" = "markdownlint";
          "color" = "blue-400";
          "lightColor" = "blue-500";
          "fileNames" = [
            ".markdownlint-cli2.yaml"
            ".markdownlint.yaml"
            "markdownlint-cli2.yaml"
            "markdownlint.yaml"
          ];
        }
        {
          "name" = "dots";
          "base" = "ionic";
          "color" = "teal-300";
          "lightColor" = "teal-600";
          "fileNames" = [
            ".dots.conf"
            ".dots.json"
            ".dots.toml"
            ".dots.txt"
            ".dotsrc"
            ".dotsrc.fish"
            ".dotsrc.nu"
            ".dotsrc.ps1"
            ".dotsrc.sh"
            "dots.json"
            "dots.toml"
          ];
        }
      ];
      "material-icon-theme.folders.associations" = {
        "_" = "base";
        ".cargo" = "config";
        "Advent-of-Code" = "Middleware";
        "ai" = "robot";
        "benches" = "debug";
        "challenges" = "Cluster";
        "crates" = "Packages";
        "day-*" = "job";
        "days" = "job";
        "desktops" = "interfaces";
        "dots" = "Cluster";
        "hosts" = "client";
        "media" = "video";
        "methods" = "Config";
        "options" = "tasks";
        "overlays" = "plugin";
        "polar" = "plastic";
        "rails" = "Debug";
        "systems" = "client";
        "traits" = "Tools";
        "trivial" = "sandbox";
        "types" = "Enum";
        "users" = "admin";
      };
      "material-icon-theme.folders.customClones" = [
        {
          "name" = "users";
          "base" = "admin";
          "color" = "light-green-300";
          "lightColor" = "light-green-700";
          "folderNames" = [
            "people"
            "roles"
            "user"
            "users"
          ];
        }
        {
          "name" = "desktops";
          "base" = "desktop";
          "color" = "purple-300";
          "lightColor" = "orange-700";
          "folderNames" = [
            "control"
            "desktop"
            "desktops"
          ];
        }
        {
          "name" = "editor";
          "base" = "skills";
          "color" = "blue-gray-600";
          "lightColor" = "blue-gray-700";
          "folderNames" = [
            "editor"
            "helix"
            "neovim"
            "nvim"
            "zed"
          ];
        }
        {
          "name" = "hosts";
          "base" = "client";
          "color" = "blue-gray-400";
          "lightColor" = "orange-700";
          "folderNames" = [
            "host"
            "hosts"
            "machine"
            "machines"
          ];
        }
        {
          "name" = "programs";
          "base" = "app";
          "color" = "cyan-300";
          "lightColor" = "green-700";
          "folderNames" = [
            "program"
            "programs"
          ];
        }
        {
          "name" = "macros";
          "base" = "middleware";
          "color" = "blue-400";
          "lightColor" = "blue-500";
          "folderNames" = [
            "constructors"
            "macros"
          ];
        }
        {
          "name" = "shell";
          "base" = "scripts";
          "color" = "blue-gray-600";
          "lightColor" = "blue-gray-500";
          "folderNames" = [
            "bash"
            "posix"
            "sh"
            "shell"
            "shells"
            "shellscript"
          ];
        }
        {
          "name" = "err";
          "base" = "error";
          "color" = "purple-400";
          "lightColor" = "red-500";
          "folderNames" = [
            "err"
            "erks"
            "error"
          ];
        }
        {
          "name" = "filesystem";
          "base" = "resource";
          "color" = "deep-purple-400";
          "lightColor" = "deep-purple-500";
          "folderNames" = [
            "file"
            "files"
            "filesystem"
            "io"
            "system"
          ];
        }
        {
          "name" = "folder";
          "base" = "archive";
          "color" = "deep-purple-300";
          "lightColor" = "deep-purple-400";
          "folderNames" = [
            "folder"
            "folders"
          ];
        }
        {
          "name" = "compression";
          "base" = "archive";
          "color" = "pink-400";
          "lightColor" = "pink-600";
          "folderNames" = [
            "compress"
            "compression"
            "extract"
            "extractor"
          ];
        }
        {
          "name" = "internal";
          "base" = "import";
          "color" = "green-300";
          "lightColor" = "green-400";
          "folderNames" = [
            "importer"
            "importers"
            "internal"
            "local"
          ];
        }
        {
          "name" = "external";
          "base" = "packages";
          "color" = "green-400";
          "lightColor" = "green-700";
          "folderNames" = [
            "external"
          ];
        }
        {
          "name" = "workspace";
          "base" = "project";
          "color" = "blue-400";
          "lightColor" = "blue-700";
          "folderNames" = [
            "workspace"
          ];
        }
        {
          "name" = "nixos";
          "base" = "quasar";
          "color" = "cyan-800";
          "lightColor" = "cyan-700";
          "folderNames" = [
            ".nix"
            "flake"
            "flakes"
            "nix"
            "nixos"
          ];
        }
        {
          "name" = "movie";
          "base" = "video";
          "color" = "orange-800";
          "lightColor" = "orange-400";
          "folderNames" = [
            "imdb"
            "movie"
          ];
        }
        {
          "name" = "string";
          "base" = "storybook";
          "color" = "light-blue-800";
          "lightColor" = "light-blue-400";
          "folderNames" = [
            "derive"
            "grammar"
            "string"
            "strings"
            "terminology"
            "terms"
            "vocabulary"
          ];
        }
        {
          "name" = "lists";
          "base" = "enum";
          "color" = "teal-600";
          "lightColor" = "teal-400";
          "folderNames" = [
            "list"
            "lists"
          ];
        }
        {
          "name" = "sets";
          "base" = "less";
          "color" = "teal-600";
          "lightColor" = "teal-400";
          "folderNames" = [
            "attr"
            "attrsets"
            "set"
            "sets"
          ];
        }
        {
          "name" = "hardware";
          "base" = "core";
          "color" = "blue-gray-400";
          "lightColor" = "blue-gray-700";
          "folderNames" = [
            "chip"
            "hardware"
            "memory"
          ];
        }
        {
          "name" = "format";
          "base" = "custom";
          "color" = "pink-800";
          "lightColor" = "pink-400";
          "folderNames" = [
            "art"
            "customize"
            "customise"
            "fmt"
            "format"
          ];
        }
        {
          "name" = "time";
          "base" = "temp";
          "color" = "teal-800";
          "lightColor" = "teal-400";
          "folderNames" = [
            "clock"
            "date"
            "ephemeral"
            "time"
          ];
        }
        {
          "name" = "registry";
          "base" = "scons";
          "color" = "purple-800";
          "lightColor" = "purple-400";
          "folderNames" = [
            "register"
            "registry"
          ];
        }
        {
          "name" = "sqlx";
          "base" = "database";
          "color" = "orange-800";
          "lightColor" = "orange-400";
          "folderNames" = [
            ".sqlx"
            "sqlx"
          ];
        }
        {
          "name" = "unit";
          "base" = "interceptor";
          "color" = "brown-800";
          "lightColor" = "brown-400";
          "folderNames" = [
            "distance"
            "measure"
            "period"
            "persistent"
            "range"
            "span"
          ];
        }
      ];
      "material-icon-theme.languages.customClones" = [
        {
          "name" = "ahk-clone";
          "base" = "autohotkey";
          "color" = "blue-400";
          "lightColor" = "grey-600";
          "ids" = [
            "ahk2"
          ];
        }
      ];
    };
  };

  animations = mkEntry {
    enabled = false;
    extensions = [
      #? Smooth UI animations
      "brandonkirbyson.vscode-animations"
    ];
    userSettings = {
      "animations.Install-Method" = "Custom UI Style";
      "animations.CursorAnimation" = true;
      "animations.CursorAnimationOptions" = {
        "Color" = "teal";
        "CursorStyle" = "block";
        "TrailLength" = 8;
      };
    };
  };

  customUI = mkEntry {
    enabled = false;
    extensions = [
      #? Custom CSS/JS UI injection
      "subframe7536.custom-ui-style"
      #? Custom CSS overrides
      "be5invis.vscode-custom-css"
      #? Acrylic/vibrancy window effect
      "illixion.vscode-vibrancy-continued"
    ];
    userSettings = with fonts.families; {
      "custom-ui-style.font.sansSerif" = sansSerif;
      "custom-ui-style.font.monospace" = monospace;
      "custom-ui-style.background.syncURL" = "file:///$\\{env:WALLPAPER\\}";
      "custom-ui-style.background.size" = "cover";
      "custom-ui-style.background.position" = "center";
      "custom-ui-style.background.opacity" = 0.94;
      "custom-ui-style.reloadWithoutPrompting" = true;
      "custom-ui-style.watch" = true;
    };
  };

  ui = mkEntry {
    enabled = true;
    userSettings = {
      #~@ Window
      "window.autoDetectColorScheme" = false;
      "window.autoDetectHighContrast" = false;
      "window.customMenuBarAltFocus" = true;
      "window.customTitleBarVisibility" = "auto";
      "window.menuBarVisibility" = "toggle";
      "window.restoreFullscreen" = true;
      "window.titleBarStyle" = "native";
      "window.zoomPerWindow" = true;

      #~@ Workbench
      "workbench.activityBar.location" = "default";
      "workbench.startupEditor" = "none";
      "workbench.panel.defaultLocation" = "bottom";
      "workbench.sideBar.location" = "right";
      "workbench.statusBar.visible" = true;
      "breadcrumbs.enabled" = true;
      "workbench.editor.empty.hint" = "hidden";
      "workbench.editor.revealIfOpen" = true;
      "workbench.editor.showTabs" = "multiple";
      "workbench.quickOpen.preserveInput" = true;
      "workbench.commandPalette.preserveInput" = true;
      "workbench.experimental.share.enabled" = true;
      "workbench.tree.enableStickyScroll" = false;
      "workbench.editor.useModal" = "off";
      "workbench.editorAssociations" = {
        "*.copilotmd" = "vscode.markdown.preview.editor";
        "{git,gitlens,chat-editing-snapshot-text-model,copilot,git-graph,git-graph-3}:/**/*.qrc" = "default";
        "{git,gitlens,chat-editing-snapshot-text-model,copilot,git-graph,git-graph-3}:/**/*.ui" = "default";
        "*.pdf" = "pdf.view";
        "*.db" = "default";
        "*.qrc" = "qt-core.qrcEditor";
        "*.tsv" = "csvViewer.csvEditor";
        "*.xlsx" = "csvViewer.csvEditor";
      };
      "workbench.colorCustomizations" = {};
    };
  };
in
  mkGroup {
    name = "appearance";
    description = "Themes, icons and UI chrome extensions";
    features = [themes icons animations customUI ui];
  }
