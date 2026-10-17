{_, ...}: let
  inherit (_.attrsets.access) attrByPath;
  inherit (_.attrsets.predicates) hasAttr;
  inherit (_.lists.construction) optional range;
  inherit (_.lists.access) head;
  inherit (_.lists.predicates) elem;
  inherit (_.lists.selection) filter;
  inherit (_.strings.predicates) hasInfix isString;
  inherit (_.strings.transformation) toLower;
  inherit (_.schema.hardware) normalizeCpu;

  cpuFor = host: normalizeCpu {inherit host;};

  # Names come from the package set, rather than assuming CachyOS upstream
  # names are attributes in the pinned Chaotic overlay.
  resolve = {
    host,
    user ? {},
    pkgs,
  }: let
    cpu = cpuFor host;
    requested = user.kernel or user.packages.kernel or host.kernel or host.packages.kernel or null;
    bare = requested != null && elem (toLower requested) ["cachy" "cachyos" "linux-cachyos"];
    compatible = cpu.arch == "x86_64";
    zen4 =
      compatible
      && cpu.level == "v4"
      && toLower (cpu.brand or "") == "amd"
      && (elem (cpu.microarch or "") ["znver4" "znver5"]
        || ((cpu.family or null)
          == 25
          && elem (cpu.model or null)
          (range 16 31 ++ range 96 127 ++ range 160 175)));
    candidates =
      optional zen4 {
        name = "linuxPackages_cachyos-lto-znver4";
        level = "zen4";
      }
      ++ optional (compatible && cpu.level != null) {
        name = "linuxPackages_cachyos-${cpu.arch}-${cpu.level}";
        inherit (cpu) level;
      }
      ++ [
        {
          name = "linuxPackages_cachyos-lto";
          level = "v1";
        }
        {
          name = "linuxPackages_cachyos";
          level = "v1";
        }
      ];
    available = filter (entry: hasAttr entry.name pkgs) candidates;
    selected =
      if requested == null
      then {
        name = "linuxPackages";
        level = null;
      }
      else if !isString requested
      then throw "kernel: expected a package name or cachyos shorthand."
      else if bare && !compatible
      then throw "kernel: CachyOS requires an x86_64 host."
      else if bare && available == []
      then throw "kernel: cachyos was requested, but no compatible CachyOS package is available."
      else if bare
      then head available
      else {
        name = requested;
        level = null;
      };
    knownLevel =
      if hasInfix "znver4" selected.name || hasInfix "zen4" selected.name
      then "zen4"
      else if hasInfix "v4" selected.name
      then "v4"
      else if hasInfix "v3" selected.name
      then "v3"
      else if hasInfix "v2" selected.name
      then "v2"
      else selected.level;
    safe =
      if knownLevel == "zen4"
      then zen4
      else if knownLevel == "v4"
      then compatible && cpu.level == "v4"
      else if knownLevel == "v3"
      then compatible && elem cpu.level ["v3" "v4"]
      else if knownLevel == "v2"
      then compatible && elem cpu.level ["v2" "v3" "v4"]
      else true;
    exists = hasAttr selected.name pkgs;
  in {
    inherit cpu requested;
    inherit (selected) name;
    level = knownLevel;
    vendor =
      if hasInfix "cachy" selected.name
      then "cachyos"
      else "nixpkgs";
    packages =
      if !safe
      then throw "kernel: '${selected.name}' exceeds the recorded CPU capability."
      else if exists
      then attrByPath [selected.name] null pkgs
      else throw "kernel: '${selected.name}' is not available in the host package set.";
    warnings =
      optional (bare && cpu.level != null && selected.level == "v1" && cpu.level != "v1")
      "kernel: CPU supports ${cpu.arch}-${cpu.level}; the pinned package set has no matching tuned kernel, using ${selected.name}.";
  };
in {
  inherit cpuFor resolve;
}
