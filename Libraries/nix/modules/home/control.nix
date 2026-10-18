{_, ...}: let
  inherit (_.schema.io) mkKeyboard;

  resolveKeyboard = {
    host,
    user,
  }: let
    keyboard = mkKeyboard {inherit host user;};
  in
    keyboard // {mod = keyboard.modifier;};

  exports.mkKeyboard = resolveKeyboard;
in
  exports
  // {
    __rootAliases = {
      mkUserKeyboard = resolveKeyboard;
    };
  }
