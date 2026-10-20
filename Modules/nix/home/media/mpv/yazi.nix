{
  pkgs,
  lix,
  terminal,
}: let
  inherit (lix.filesystem.access) readFile;
  inherit (lix.filesystem.construction) mkPath;
  inherit (lix.strings.construction) concat;
  inherit (lix.strings.transformation) replaceStrings;
  inherit (pkgs) writeTextDir;

  script = {
    name = "yazi.lua";
    source =
      replaceStrings
      ["@terminalCommand@" "@terminalExecFlag@"]
      (with terminal; [command (wrap.execFlag or "-e")])
      (readFile (mkPath ["Configuration" "mpv" script.name]));
  };
in
  (
    writeTextDir
    (concat "/" ["share" "mpv" "scripts" script.name])
    script.source
  ).overrideAttrs
  (previous: {
    passthru =
      (previous.passthru or {})
      // {scriptName = script.name;};
  })
