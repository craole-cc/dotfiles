# Persistent Helix Scratchpad

The Helix registry entry selects `helix-session` for scratchpad launches. The
Home Manager Helix module installs that launcher. Keys and application order
continue to come from the user API; plain `hx` starts a normal Helix process.

The launcher creates or attaches to session `helix` on the dedicated tmux server
`dotdots-helix`. Closing the terminal detaches its client while Helix keeps its
open files, unsaved buffers and cursor position. Reopening the scratchpad
reattaches to that same process. The dedicated server hides its status bar and
disables the tmux prefix so editor shortcuts keep reaching Helix.

Explicitly quitting Helix ends this session. The next launch starts a fresh
editor. A reboot also ends the session; this is process persistence, not a saved
session on disk.

A Helix window opened before this change is still an ordinary process. Save and
quit it once, then reopen the scratchpad to start the persistent session. You can
also run `helix-session` from a terminal after activation.
