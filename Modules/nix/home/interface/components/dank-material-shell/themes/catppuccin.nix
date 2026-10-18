{
  config,
  lix,
  user,
}:
let
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.strings.transformation) escapeShellArg;

  configHome = config.xdg.configHome or "${user.home}/.config";
  name = "catppuccin";
  path = concat {
    root = configHome;
    stem = [
      "DankMaterialShell"
      "themes"
      "${name}.json"
    ];
  };
in
{
  inherit name path;
  pathStr = escapeShellArg path;
  source = ./catppuccin.json;
}
