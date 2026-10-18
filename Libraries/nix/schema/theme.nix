{_, ...}: let
  inherit (_.attrsets.aggregation) recursiveUpdate;

  getTheme = definition:
    recursiveUpdate (definition.theme or {}) (definition.interface.theme or {});

  mkTheme = {
    host ? {},
    user ? {},
  }: let
    hostInterface = host.defaults.interface or (host.interface or {});
  in
    recursiveUpdate (getTheme (host // {interface = hostInterface;})) (getTheme user);
in {
  inherit getTheme mkTheme;
}
