{
  lix,
  pkgs,
  cfg,
  ...
}: let
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.combinators) attrsOf either;
  inherit (lix.types.primitives) anything path;
  inherit (pkgs.stdenv) mkDerivation;
in {
  options.hooks = mkOption {
    type = either path (attrsOf anything);
    default.PreToolUse = [
      {
        matcher = "^Bash$";
        hooks = [
          {
            type = "command";
            command = "${mkDerivation {
              name = "codex-guard-destructive";
              src = ./guard.zig;
              dontUnpack = true;
              nativeBuildInputs = with pkgs; [zig];
              buildPhase = ''
                export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
                export ZIG_LOCAL_CACHE_DIR="$TMPDIR/zig-local-cache"
                zig build-exe $src -O ReleaseSmall --name codex-guard-destructive
              '';
              installPhase = ''
                mkdir -p $out/bin
                cp codex-guard-destructive $out/bin/
              '';
            }}/bin/codex-guard-destructive";
            timeout = 10;
            statusMessage = "Checking for destructive commands";
          }
        ];
      }
    ];
    description = ''
      Lifecycle hooks written to `~/.codex/hooks.json` (`programs.codex.hooks`).
      Either an attribute set of events or a path to a hooks bundle. The default
      blocks recursive deletes of `/` or `$HOME`, `mkfs`, and `dd` onto devices.
    '';
  };

  settings = {
    features = optionalAttrs (cfg.hooks != {}) {hooks = true;};
  };

  programs = {inherit (cfg) hooks;};
}
