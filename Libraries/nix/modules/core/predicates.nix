{_, ...}: let
  inherit (_.lists.predicates) elem;
  inherit (_.strings.predicates) hasPrefix;

  isSystemDefaultUser = name:
    (hasPrefix "nixbld" name)
    || (hasPrefix "systemd-" name)
    || (elem name [
      "dhcpcd"
      "fwupd-refresh"
      "geoclue"
      "messagebus"
      "nm-iodine"
      "nm-openvpn"
      "nobody"
      "nscd"
      "polkituser"
      "root"
      "rtkit"
      "sddm"
      "gdm"
    ]);

  exports = {inherit isSystemDefaultUser;};
in
  exports // {__rootAliases = exports;}
