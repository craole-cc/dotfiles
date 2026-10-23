{
  lix,
  config,
  context,
  ...
}: let
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.filesystem.construction) concat;

  enabled = context.wantsDmsShell.condition;

  # DMS only discovers its VS Code integration by finding a writable
  # `danklinux.dms-theme-*` extension in the editor's normal extensions
  # directory. Keep this one extension mutable because Matugen rewrites its
  # theme JSON files whenever DMS colors change.
  source = concat {
    # The output omits the extension sources; follow the selected package's source.
    root = config.programs.dank-material-shell.package.src;
    stem = ["quickshell" "matugen" "vsix-build"];
  };

  settings = optionalAttrs enabled {
    # DMS rewrites the default theme in place to follow its own runtime mode.
    # Letting VS Code independently follow the desktop portal races that
    # mechanism and can make it select a light theme while DMS is dark.
    "window.autoDetectColorScheme" = false;
    "workbench.colorTheme" = "Dynamic Base16 DankShell";
  };
in {inherit enabled source settings;}
