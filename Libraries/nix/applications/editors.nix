{_, ...}: let
  inherit (_.attrsets.resolution) parseVscodeExt vscodePackage;
  inherit (_.attrsets.construction) optionalAttrs;
  inherit (_.lists.construction) optionals;

  __exports = {
    internal = {
      inherit
        mkVSCodeFeature
        mkVSCodeSubFeature
        mkHelixFeature
        mkNeovimFeature
        ;
    };
    external = __exports.internal;
  };

  mkVSCodeFeature = {
    enabled,
    extensions,
    userSettings ? {},
    pkgs,
    inputs,
  }:
    {
      extensions = optionals enabled (map (extension: let
        identifier = parseVscodeExt extension;
      in
        vscodePackage {
          inherit pkgs inputs;
          entry = extension;
          default = throw "Required VS Code extension '${identifier.publisher}.${identifier.name}' was not found in the configured extension catalogues.";
        })
      extensions);
    }
    // optionalAttrs enabled {inherit userSettings;};

  mkVSCodeSubFeature = {
    enabled,
    extensions ? [],
    userSettings ? {},
  }:
    {extensions = optionals enabled extensions;} // optionalAttrs enabled {inherit userSettings;};

  mkHelixFeature = {
    enabled,
    languages ? {},
    themes ? {},
  }:
    optionalAttrs enabled {inherit languages themes;};

  mkNeovimFeature = {
    enabled,
    plugins ? [],
    extraConfig ? "",
  }:
    optionalAttrs enabled {inherit plugins extraConfig;};
in
  __exports.internal // {__rootAliases = __exports.external;}
