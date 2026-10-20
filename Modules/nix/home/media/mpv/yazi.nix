{
  pkgs,
  lix,
  terminal,
  mod,
  ...
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
      (readFile (mkPath ["Configuration" mod script.name]));
  };
  package =
    writeTextDir
    (concat "/" ["share" mod "scripts" script.name])
    script.source;
in
  package.overrideAttrs (prev: {
    passthru = (prev.passthru or {}) // {scriptName = script.name;};
  })
