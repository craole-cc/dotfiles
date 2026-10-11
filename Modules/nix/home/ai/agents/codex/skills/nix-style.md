---
name: nix-style
description: House style for Nix modules and expressions. Use whenever writing or editing .nix files.
---

# Nix style

- Use descriptive variable names, never single-letter ones, including lambda arguments.
- Write functions with positional arguments, not a single-attribute attrset such as `{user}:`.
- Group related module options under a namespace (`approval.policy`, `approval.reviewer`) rather than flat camelCase names.
- Give every option a real type, a default and a description. Do not use hidden baseline attrsets or on/off "defaults" switches.
- Merge settings layers key by key with module-system priorities (`mkOverride`, `mkMerge`) instead of replacing a whole attrset.
