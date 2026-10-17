{
  config,
  host,
  lix,
  pkgs,
  top ? "_",
  ...
}: let
  inherit (lix.attrsets.access) attrByPath attrValues;
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.lists.access) head;
  inherit (lix.lists.aggregation) concatMap;
  inherit (lix.lists.construction) toList;
  inherit (lix.lists.transformation) unique;
  inherit (lix.modules.construction) mkConfig mkContext;
  inherit (lix.options.construction) mkOption mkTrue;
  inherit (lix.schema.fonts) mkFonts;
  inherit (lix.strings.construction) splitString;
  inherit (lix.types.combinators) either listOf;
  inherit (lix.types.predicates) isString;
  inherit (lix.types.primitives) package str;

  context = mkContext {
    inherit config top;
    dom = "interface";
    sub = "style";
    mod = "fonts";
  };
  inherit (context) cfg;

  selected = mkFonts {
    inherit host;
    user = host.users.data.primary or {};
  };
  names = mapAttrs (_: entries: unique (map (entry: entry.name) entries)) selected;
  roles = (removeAttrs names ["sans"]) // {sansSerif = names.sans;};

  resolvePackage = entry:
    if entry.package == null
    then []
    else [
      (
        if isString entry.package
        then
          attrByPath (splitString "." entry.package)
          (throw "Unknown font package '${entry.package}' for '${entry.name}'.")
          pkgs
        else entry.package
      )
    ];
  users = attrValues (host.users.data.enabled or {});
  selections = [selected] ++ map (user: mkFonts {inherit host user;}) users;
  packages = unique (concatMap (fonts: concatMap resolvePackage (concatMap toList (attrValues fonts))) selections);
  first = role:
    if cfg.${role} == []
    then ""
    else head cfg.${role};
in
  mkConfig {
    inherit context;
    options =
      {
        enable = mkTrue "fonts";
        packages = mkOption {
          description = "Font packages for every ordered selection of enabled users";
          default = packages ++ [pkgs.corefonts];
          type = listOf package;
        };
      }
      // mapAttrs (role: default:
        mkOption {
          description = "Ordered ${role} font families, with the preferred family first";
          inherit default;
          type = either str (listOf str);
          apply = toList;
        })
      roles;

    outputs = {
      fonts = {
        inherit (cfg) packages;
        enableDefaultPackages = true;
        enableFontDir = true;
        enableGhostscriptFonts = true;
        fontDir.enable = true;
        fontconfig = {
          enable = true;
          defaultFonts = {
            inherit (cfg) monospace sansSerif serif emoji;
          };
        };
      };
      environment.sessionVariables = {
        FONT_CLOCK = first "clock";
        FONT_EMOJI = first "emoji";
        FONT_MATERIAL = first "material";
        FONT_MONO = first "monospace";
        FONT_MONOSPACE = first "monospace";
        FONT_SANS = first "sansSerif";
        FONT_SERIF = first "serif";
      };
    };
  }
