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
    extensions,
    userSettings ? {},
    keybindings ? [],
    pkgs,
    inputs,
    ...
  } @ args: let
    enable = args.enable or (args.enabled or false);
  in
    {
      extensions = optionals enable (
        map (
          extension: let
            identifier = parseVscodeExt extension;
          in
            vscodePackage {
              inherit pkgs inputs;
              entry = extension;
              default = throw "Required VS Code extension '${identifier.publisher}.${identifier.name}' was not found in the configured extension catalogues.";
            }
        )
        extensions
      );
      keybindings = optionals enable keybindings;
    }
    // optionalAttrs enable {inherit userSettings;};

  mkVSCodeSubFeature = {
    extensions ? [],
    userSettings ? {},
    keybindings ? [],
    ...
  } @ args: let
    enable = args.enable or (args.enabled or false);
  in
    {
      extensions = optionals enable extensions;
      keybindings = optionals enable keybindings;
    }
    // optionalAttrs enable {inherit userSettings;};

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
