{
  host,
  inputs,
  lix,
  pkgs,
  ...
}: let
  inherit (lix.applications.registry) resolve;
  inherit (lix.applications.runtime) resolvePackage;
  inherit (lix.attrsets.access) attrByPath;
  inherit (lix.debug.tracing) tryEval;
  inherit (lix.lists.transformation) unique;
  inherit (lix.schema.applications) mkApplications;
  inherit (lix.strings.construction) splitString;
  inherit (pkgs.stdenv.hostPlatform) system;

  required = (mkApplications {inherit host;}).requiredPackages;
  packageFor = name: let
    registered = tryEval (resolve {value = name;});
    package =
      if registered.success && (registered.value.package.attribute or null) != null
      then
        resolvePackage {
          inherit inputs pkgs system;
          app = registered.value;
        }
      else attrByPath (splitString "." name) null pkgs;
  in
    if package == null
    then throw "Host '${host.name}' requires package '${name}', but it could not be resolved."
    else package;
in {
  environment.systemPackages = unique (map packageFor required);
}
