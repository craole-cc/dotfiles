#TODO: This is almost identical to the home variant, we need to normalize in schema
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
  inherit (lix.lists.access) findFirst head;
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
  roles = (removeAttrs names ["sans"]) // {sansSerif = names.sansSerif or names.sans;};

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

  # Helper to resolve the matching package derivation for application options requiring it
  firstPackage = role: let
    preferredName = first role;
    allEntries = concatMap toList (attrValues selected);
    matchingEntry = findFirst (e: e.name == preferredName) null allEntries;
  in
    if matchingEntry != null && matchingEntry.package != null
    then
      (
        if isString matchingEntry.package
        then attrByPath (splitString "." matchingEntry.package) null pkgs
        else matchingEntry.package
      )
    else null;

  resolved = {
    clock = let
      tag = "clock";
      name = first tag;
      package = firstPackage tag;
      size = 11;
    in {
      inherit name package size;
      FONT_CLOCK = name;
    };

    math = let
      tag = "math";
      name = first tag;
      package = firstPackage tag;
      size = 11;
    in {
      inherit name package size;
      FONT_MATH = name;
    };

    music = let
      tag = "music";
      name = first tag;
      package = firstPackage tag;
      size = 11;
    in {
      inherit name package size;
      FONT_MUSIC = name;
    };

    emoji = let
      tag = "emoji";
      name = first tag;
      package = firstPackage tag;
      size = 11;
    in {
      inherit name package size;
      FONT_EMOJI = name;
    };

    material = let
      tag = "material";
      name = first tag;
      package = firstPackage tag;
      size = 11;
    in {
      inherit name package size;
      FONT_MATERIAL = name;
    };

    monospace = let
      tag = "monospace";
      name = first tag;
      package = firstPackage tag;
      size = 11;
    in {
      inherit name package size;
      FONT_MONO = name;
      FONT_MONOSPACE = name;
    };

    sansSerif = let
      tag = "sansSerif";
      name = first tag;
      package = firstPackage tag;
      size = 11;
    in {
      inherit name package size;
      FONT_SANS = name;
      FONT_SANSSERIF = name;
    };

    serif = let
      tag = "serif";
      name = first tag;
      package = firstPackage tag;
      size = 11;
    in {
      inherit name package size;
      FONT_SERIF = name;
    };
  };
in
  mkConfig {
    inherit context;
    options =
      {
        enable = mkTrue "fonts";
        packages = mkOption {
          description = "Font packages for every ordered selection of enabled users";
          default = packages;
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
      home.packages = cfg.packages;

      fonts.fontconfig = {
        antialiasing = true;
        enable = true;
        defaultFonts = {inherit (cfg) monospace sansSerif serif emoji;};
      };

      xdg.configFile."fontconfig/conf.d/99-monospace-override.conf".text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <test qual="any" name="family"><string>monospace</string></test>
            <edit name="family" mode="prepend" binding="strong">
              <string>${resolved.monospace.name}</string>
            </edit>
          </match>
        </fontconfig>
      '';

      home.sessionVariables = with resolved; {
        inherit (clock) FONT_CLOCK;
        inherit (math) FONT_MATH;
        inherit (emoji) FONT_EMOJI;
        inherit (material) FONT_MATERIAL;
        inherit (monospace) FONT_MONO FONT_MONOSPACE;
        inherit (sansSerif) FONT_SANS FONT_SANSSERIF;
        inherit (serif) FONT_SERIF;
      };

      gtk.font = {inherit (resolved.sansSerif) name package size;};

      dconf.settings."org/gnome/desktop/interface" = {
        font-name = with resolved.sansSerif; "${name} ${toString size}";
        document-font-name = with resolved.serif; "${name} ${toString size}";
        monospace-font-name = with resolved.monospace; "${name} ${toString size}";
      };

      # programs = let
      #   inherit (resolved.monospace) name package size;
      # in {
      #   ghostty.settings = {
      #     font-family = name;
      #     font-size = size;
      #   };
      #   kitty.font = {inherit name package size;};
      #   foot.settings.main.font = "${name} ${toString size}";
      #   termite.font = "${name} ${toString size}";
      #   urxvt.fonts = ["xft:${name}:size=${toString size}"];
      #   vscode.profiles.default.userSettings = {
      #     "editor.fontFamily" = "'${name}', monospace";
      #     "editor.fontSize" = size;
      #     "editor.fontLigatures" = true;
      #     "terminal.integrated.fontFamily" = name;
      #     "terminal.integrated.fontSize" = size + 3;
      #   };
      #   zed-editor.userSettings = {
      #     ui_font_size = size + 3;
      #     buffer_font_family = name;
      #     buffer_font_size = size;
      #   };
      # };
    };
  }
