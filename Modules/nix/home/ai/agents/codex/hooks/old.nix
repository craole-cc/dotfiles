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

  destructiveCommandGuard = pkgs.writeShellApplication {
    name = "codex-guard-destructive";
    runtimeInputs = with pkgs; [jaq ripgrep];
    text = ''
      shell_command="$(jaq -r '.tool_input.command // empty')"

      blocked_patterns=(
        'rm +(-[a-zA-Z]+ +)*(/|~|\$HOME|/\*)( |$)'
        'mkfs(\.| )'
        'dd +.*of=/dev/'
      )

      for pattern in "''${blocked_patterns[@]}"; do
        if printf '%s' "$shell_command" | rg -q -- "$pattern"; then
          echo "Blocked by codex-guard-destructive: matches /$pattern/" >&2
          exit 2
        fi
      done
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
  settings.features = optionalAttrs (cfg.hooks != {}) {hooks = true;};

  programs = {inherit (cfg) hooks;};
}
