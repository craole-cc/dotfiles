---
name: nix-inspect
description: Inspect evaluated Nix and Home Manager configuration without building or deploying. Use when debugging option values, merges, or generated files.
---

# Inspecting Nix configuration

- Print an option in `nix repl` with `:p config.<path>`. Derivations print as `«derivation ...»`, which is not valid syntax to paste back.
- To read a generated file, use `builtins.readFile <attribute>.source`. The store path may not exist until it is built.
- Prefer `nix eval` for one-off checks. Never run switch, boot or deploy commands; ask the user to.
