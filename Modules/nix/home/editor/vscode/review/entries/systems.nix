{
  mkGroup,
  mkEntry,
  ...
}: let
  rust = mkEntry {
    enable = true;
    extensions = [
      #? Rust LSP
      "rust-lang.rust-analyzer"
      #? LLDB debugger for Rust/C++
      "vadimcn.vscode-lldb"
      #? Rust/Go dependency version checker
      "fill-labs.dependi"
    ];
    userSettings = {
      "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";
      "rust-analyzer.check.command" = "clippy";
      "rust-analyzer.cargo.features" = "all";
      "lldb.suppressUpdateNotifications" = true;
      "lldb.showDisassembly" = "auto";
      "lldb.dereferencePointers" = true;
      "lldb.consoleMode" = "commands";
    };
  };

  shell = mkEntry {
    enable = true;
    extensions = [
      #? shell script formatter
      "mkhl.shfmt"

      #? Bash IDE
      "mads-hartmann.bash-ide-vscode"

      #? shell script linter
      "timonwong.shellcheck"

      #? additional shell formatting
      "foxundermoon.shell-format"

      #? improved shell highlighting
      "jeff-hykin.better-shellscript-syntax"
    ];
    userSettings = {
      "[shellscript]"."editor.defaultFormatter" = "mkhl.shfmt";
      "[bats]"."editor.defaultFormatter" = "mkhl.shfmt";
      "[dotenv]"."editor.defaultFormatter" = "mkhl.shfmt";
      "bashIde.explainshellEndpoint" = "http://localhost:5000";
      "zig.zls.enabled" = "on";
    };
  };
in {entries = {inherit rust shell;};}
