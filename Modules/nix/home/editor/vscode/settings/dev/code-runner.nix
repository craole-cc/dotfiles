_: {
  # Shared Code Runner configuration.
  # Imported once per profile so `code-runner.executorMap` is defined in exactly one place.
  # Setting `executorMap` replaces the whole map; languages not listed fall back to Code
  # Runner's built-in defaults.
  extensions = [
    "formulahendry.code-runner"
  ];
  settings = {
    code-runner = {
      #> Run in the integrated terminal instead of the read-only Output panel. Required for interactive programs (stdin, TUI, REPLs).
      runInTerminal = true;

      #> Save the file before running, so you never run stale code.
      saveFileBeforeRun = true;

      #> Keep focus in the editor after running instead of jumping to the terminal.
      preserveFocus = false;

      #> Clear previous output before each run.
      clearPreviousOutput = true;

      #> Per-language run commands. Replaces the built-in map for listed languages; unlisted languages keep their built-in defaults.
      #? Placeholders ($dir, $workspaceRoot, $fileName, $fileNameWithoutExt, $file) are Code
      #? Runner's own — bare `$`, no braces — so they need no Nix escaping.
      executorMap = {
        #> Rust: go through cargo so features, deps, and the workspace resolve.
        #? Run from the workspace root; `cargo run` errors in multi-bin crates without `--bin`.
        rust = "cd $workspaceRoot && cargo run";

        #> Zig: go through the build system so `@import` and the module graph resolve.
        #? Requires a `run` step in `build.zig` (present in `zig init` projects).
        zig = "cd $dir && zig build run";

        #> POSIX sh: `sh` explicitly, so a bash-isms file fails loudly instead of silently working under bash.
        sh = "cd $dir && sh $fileName";

        #> Bash: `bash` explicitly. (Code Runner's default is `bash`, so this is mostly documentation.)
        bash = "cd $dir && bash $fileName";

        #> Nushell: `nu`. Loads your config automatically; use `nu --no-config-file` to skip it.
        nu = "cd $dir && nu $fileName";

        #> Nix: evaluate the file and print the result. `nix-instantiate --eval` for pure data,
        #? `nix eval --file` for flakes-aware eval. This is a REPL-style eval, not a "run".
        nix = "cd $dir && nix-instantiate --eval --strict $fileName";

        #> Python: use the active interpreter (venv-aware) via `python`, not `python3`,
        #? so the selected environment is honoured.
        python = "cd $dir && python $fileName";

        #> SQL: depends on your engine. Uncomment the one you use; Code Runner has no
        #? sensible universal default. `sqlite3` is the most common local option.
        #? sql = "cd $dir && sqlite3 :memory: < $fileName";
      };
    };
  };
  keybindings = [
    #> Run the current file via Code Runner.
    #? Only needed if the extension's default Ctrl+Alt+N is grabbed by your WM.
    {
      key = "ctrl+alt+r";
      command = "code-runner.run";
      when = "editorTextFocus && !inDebugRepl";
    }
    #> Stop the running Code Runner process.
    #? Only needed if the extension's default Ctrl+Alt+M is grabbed by your WM.
    {
      key = "ctrl+alt+e";
      command = "code-runner.stop";
    }
  ];
}
