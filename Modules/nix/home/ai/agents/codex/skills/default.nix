{
  lix,
  pkgs,
  inputs,
  cfg,
  ...
}: let
  inherit (lix.attrsets.access) attrNames;
  inherit (lix.attrsets.construction) listToAttrs;
  inherit (lix.filesystem.access) readDir readFile;
  inherit (lix.filesystem.primitives) concat;
  inherit (lix.lists.transformation) filter;
  inherit (lix.options.construction) mkOption;
  inherit (lix.strings.access) stringLength substring;
  inherit (lix.strings.predicates) hasSuffix;
  inherit (lix.types.combinators) attrsOf either listOf;
  inherit (lix.types.primitives) lines path str;

  openai = let
    source = (inputs.codex-skills or {}).outPath or pkgs.fetchFromGitHub {
      #? OpenAI's curated skills, pinned. To update:
      #? - bump `rev`,
      #? - set `hash` to lib.fakeHash
      #? - attempt build
      #? - copy the discovered hash Nix reports.
      owner = "openai";
      repo = "skills";
      rev = "49f948faa9258a0c61caceaf225e179651397431";
      hash = "sha256-t4oGnFg0YpxJaQiFpgTiwYhaFoZK6wPDiqvHoG0bXiU=";
    };
    target = name: let
      path = concat {
        root = source;
        stem = ["skills" ".curates" name];
      };
    in
      path;
  in {inherit source target;};

  #> Dynamically collect all custom `.md` skills in this directory.
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
      value = openai.target name;
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
        Extra skills by name (`programs.skills`): inline content, a path to a SKILL.md
        file, or a store path string to a skill folder. These overlay curated and
        local repository skills.
      '';
    };
  };

  program.skills = curated // custom // cfg.skills;
}
