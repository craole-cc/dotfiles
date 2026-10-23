{
  lib,
  flatten ? false,
  ...
}: let
  __exports = {
    namespaced = {inherit access construction predicates;};
    flattened = {} // access // construction // predicates // {};
  };

  inherit (lib) trivial;

  access = {};
  construction = {};

  predicates = {
    inherit (trivial) lessThan;
  };
in
  if flatten
  then __exports.namespaced // __exports.flattened
  else __exports.namespaced
