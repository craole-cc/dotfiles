{
  lix,
  pkgs,
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
  inherit (lix.types.combinators) attrsOf either listOf;
  inherit (lix.types.primitives) lines path str;

  # OpenAI's curated skills, pinned. To update: bump `rev`, set `hash` to an
  # empty string, build once, and copy the hash Nix reports.
  openai = pkgs.fetchFromGitHub {
    owner = "openai";
    repo = "skills";
    rev = "49f948faa9258a0c61caceaf225e179651397431";
    hash = "sha256-t4oGnFg0YpxJaQiFpgTiwYhaFoZK6wPDiqvHoG0bXiU=";
  };

  # A store path string makes Home Manager symlink the whole skill folder,
  # which keeps its scripts. A literal Nix path would be read as one file.
  fromOpenai = name: "${openai}/skills/.curated/${name}";

  # Every .md file here is one skill, named after its file. Drop a new
  # `<name>.md` next to this file and it is picked up with no Nix edits.
  entries = readDir ./.;
  custom = listToAttrs (
    map (file: {
      name = substring 0 (stringLength file - 3) file;
      value = readFile (./. + "/${file}");
    })
    (
      filter
      (file: entries.${file} == "regular" && hasSuffix ".md" file)
      (attrNames entries)
    )
  );

  curated = listToAttrs (
    map (name: {
      inherit name;
      value = fromOpenai name;
    })
    cfg.curated.skills
  );
in {
  options = {
    curated.skills = mkOption {
      type = listOf str;
      default = ["gh-fix-ci" "gh-address-comments"];
      description = ''
        Skills to install from OpenAI's curated set, by folder name under
        `skills/.curated/` in github.com/openai/skills. Setting this replaces
        the default list.
      '';
    };

    skills = mkOption {
      type = attrsOf (either lines path);
      default = {};
      description = ''
        Extra skills by name (`programs.codex.skills`): inline content, a path to
        a SKILL.md file, or a store path string to a skill folder. They are added
        to the `curated` ones and the `.md` files in the `skills/` folder; a
        later layer replaces an earlier one with the same name.
      '';
    };
  };

  programs.skills = curated // custom // cfg.skills;
}
