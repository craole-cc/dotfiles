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

  destructiveCommandGuard = mkDerivation {
    name = "codex-guard-destructive";
    src = ./.;
    nativeBuildInputs = with pkgs; [zig];
    buildPhase = ''
      export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
      zig build-exe guard.zig -O ReleaseSmall --name codex-guard-destructive
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp codex-guard-destructive $out/bin/
    '';
  };
in {
  options.hooks = mkOption {
    type = either path (attrsOf anything);
    default.PreToolUse = [
      {
        matcher = "^Bash$";
        hooks = [
          {
            type = "command";
            command = "${destructiveCommandGuard}/bin/codex-guard-destructive";
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

  # Hooks sit behind a feature flag, so switch it on whenever any are defined.
  settings = {
    features = optionalAttrs (cfg.hooks != {}) {hooks = true;};
  };

  programs = {inherit (cfg) hooks;};
}
