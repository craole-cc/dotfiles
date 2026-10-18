{
  config,
  lix,
  name,
  pkgs,
  ...
}: let
  inherit (lix.sources.access) getExe;
  tmuxConfig = pkgs.writeText "helix-session-tmux.conf" ''
    # Keep the editor alive after its terminal client closes.
    set -g destroy-unattached off
    set -g status off
    set -g prefix None
    unbind-key C-b
    set -g default-terminal "tmux-256color"
    set -as terminal-features ",*:RGB"
    set -s escape-time 0
  '';
in
  pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [pkgs.tmux];
    text = ''
      # A separate server keeps this editor independent of ordinary tmux sessions.
      unset TMUX
      exec tmux -L dotdots-helix -f ${tmuxConfig} \
        new-session -A -s helix -n helix -- \
        ${getExe config.programs.helix.package} "$@"
    '';
  }
