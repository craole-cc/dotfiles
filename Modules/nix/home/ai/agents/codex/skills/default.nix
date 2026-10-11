{
  lix,
  cfg,
  ...
}: let
  inherit (lix.attrsets.access) attrNames;
  inherit (lix.attrsets.construction) listToAttrs;
  inherit (lix.filesystem.access) readDir readFile;
  inherit (lix.lists.transformation) filter;
  inherit (lix.options.construction) mkOption;
  inherit (lix.strings.access) stringLength substring;
  inherit (lix.strings.predicates) hasSuffix;
  inherit (lix.types.combinators) attrsOf either;
  inherit (lix.types.primitives) lines path;

  # Every .md file here is one skill, named after its file. Drop a new
  # `<name>.md` next to this file and it is picked up with no Nix edits.
  entries = readDir ./.;
  skillFiles =
    filter
    (file: entries.${file} == "regular" && hasSuffix ".md" file)
    (attrNames entries);

  discovered = listToAttrs (
    map (file: {
      name = substring 0 (stringLength file - 3) file;
      value = readFile (./. + "/${file}");
    })
    skillFiles
  );
in {
  options.skills = mkOption {
    type = attrsOf (either lines path);
    default = {};
    description = ''
      Extra skills by name, as inline content or a path to a skill directory.
      They are added to the `.md` files in the `skills/` folder
      (`programs.codex.skills`); a name that matches a file replaces it.
    '';
  };

  programs.skills = discovered // cfg.skills;
}
