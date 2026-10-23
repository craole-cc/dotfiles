{_, ...}: let
  inherit (_.filesystem.access) readFile;
  inherit (_.filesystem.primitives) concat;
  inherit (_.strings.construction) fromJSON;
  inherit (_.attrsets.predicates) isAttrs;

  exports = let
    aliases = {readJSONFile = readJSON;};
  in {
    internal = {inherit readJSON;} // aliases;
    external = aliases;
  };

  readJSON = args: let
    root =
      if isAttrs args
      then args.root or null
      else null;
    stem =
      if isAttrs args
      then args.stem or null
      else null;
    path =
      if isAttrs args
      then args.path or null
      else args;
    file =
      if path != null
      then path
      else if root != null && stem != null
      then concat {inherit root stem;}
      else throw "readJSON: provide `path`, or provide both `root` and `stem`.";
  in
    fromJSON (readFile file);
in
  exports // {__rootAliases = exports;}
