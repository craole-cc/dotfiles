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
    enable,
    extensions,
    userSettings ? {},
    pkgs,
    inputs,
  }:
    {
      extensions = optionals enable (map (extension: let
        identifier = parseVscodeExt extension;
      in
        vscodePackage {
          inherit pkgs inputs;
          entry = extension;
          default = throw "Required VS Code extension '${identifier.publisher}.${identifier.name}' was not found in the configured extension catalogues.";
        })
      extensions);
    }
    // optionalAttrs enable {inherit userSettings;};

  mkVSCodeSubFeature = {
    enable,
    extensions ? [],
    userSettings ? {},
  }:
    {extensions = optionals enable extensions;} // optionalAttrs enable {inherit userSettings;};

  mkHelixFeature = {
    enable,
    languages ? {},
    themes ? {},
  }:
    optionalAttrs enable {inherit languages themes;};

  mkNeovimFeature = {
    enable,
    plugins ? [],
    extraConfig ? "",
  }:
    optionalAttrs enable {inherit plugins extraConfig;};
in
  __exports.internal // {__rootAliases = __exports.external;}
