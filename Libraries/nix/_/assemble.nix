{
  lib,
  handleCollisions,
  library,
  paths,
  allowAliases,
}: let
  inherit (lib.attrsets) attrNames filterAttrs genAttrs recursiveUpdate;
  inherit (lib.lists) filter;
  inherit (lib.filesystem) readDir;
  inherit (lib.strings) hasSuffix removeSuffix;

  lib' = let
    base = let
      path = paths.repo.lib.default.store + "/imports";
      entries = readDir path;
      names = map (file: removeSuffix ".nix" file) (
        attrNames (
          filterAttrs
          (
            name: type:
              (type == "regular")
              && (hasSuffix ".nix" name)
              && (name != "default.nix")
          )
          entries
        )
      );
      load = name:
        import (path + "/${name}.nix") {
          inherit lib;
          flatten = false;
        };
    in
      genAttrs names load;
    # base = let
    #   path = paths.repo.lib.default.store + "/imports";
    #   # TODO: Auto import all files in path, i want the default to be a mere stub {}
    #   set = import path;
    #   init = fn:
    #     fn {
    #       inherit lib;
    #       flatten = false;
    #     };
    #   names = filter (name: name != "default") (
    #     map (file: removeSuffix ".nix" file) (
    #       attrNames (
    #         filterAttrs
    #         (
    #           name: type:
    #             (type == "regular")
    #             && (hasSuffix ".nix" name)
    #             && (name != "default.nix")
    #         )
    #         (readDir path)
    #       )
    #     )
    #   );
    # in
    #   genAttrs names (name: init set.${name});
  in
    library.extend (_: prev: recursiveUpdate base prev);

  custom = lib'.extend (
    _: prev:
      recursiveUpdate prev {
        # src = paths.repo.src.store;
        inherit lib;
      }
  );

  base = removeAttrs custom [
    "__rootAliases"
    "__unfix__"
    "unfix"
    "extend"
  ];
in
  (
    if allowAliases
    then
      handleCollisions {
        inherit base;
        overrides = custom.__rootAliases or {};
        msg = "Root aliases collide with modules";
      }
    else base
  )
  // {extend = fn: custom.extend fn;}
