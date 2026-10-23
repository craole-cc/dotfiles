{
  lix,
  tools,
  context,
  ...
}: let
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.filesystem.access) readJSON;
  inherit (lix.filesystem.construction) concat;

  enabled = context.wantsDmsShell.condition;

  # DMS only discovers its VS Code integration by finding a writable
  # `danklinux.dms-theme-*` extension in the editor's normal extensions
  # directory. Keep this one extension mutable because Matugen rewrites its
  # theme JSON files whenever DMS colors change.
  source =
    if tools ? dms && tools.dms.package ? src
    then
      concat {
        root = tools.dms.package.src;
        stem = ["quickshell" "matugen" "vsix-build"];
      }
    else null;

  meta =
    if source != null
    then
      readJSON {
        root = source;
        stem = "package.json";
      }
    else null;
  home =
    if meta != null
    then "danklinux.dms-theme-${meta.version}"
    else null;

  settings = optionalAttrs enabled {
    # DMS rewrites the default theme in place to follow its own runtime mode.
    # Letting VS Code independently follow the desktop portal races that
    # mechanism and can make it select a light theme while DMS is dark.
    "window.autoDetectColorScheme" = false;
    "workbench.colorTheme" = "Dynamic Base16 DankShell";
  };
in {inherit source meta home settings;}
