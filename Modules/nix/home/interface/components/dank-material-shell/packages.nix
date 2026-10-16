{
  inputs,
  lix,
  pkgs,
}: let
  inherit (lix.sources.packages) pkgsFrom;
  tools = pkgsFrom {
    inherit inputs pkgs;
    sources = {
      coreutils = null;
      dms-shell = null;
      glib = null;
      jaq = null;
      procps = {exe = "pkill";};
      quickshell = null;
      ripgrep = null;
      sd = null;
    };
    required = true;
  };

  bins = let
    inherit (tools) binaries;
    coreutils = "${tools.coreutils.paths.binary}";
    glib = "${tools.glib.paths.binary}";
  in rec {
    inherit (binaries) jaq sd;
    cat = "${coreutils}/cat";
    chmod = "${coreutils}/chmod";
    cmp = "${coreutils}/cmp";
    dirname = "${coreutils}/dirname";
    dms = binaries.dms-shell;
    dmsCall = "${dms} ipc call";
    dmsSet = "${dmsCall} settings set";
    gCall = "${glib}/gdbus call";
    gSet = "${gsettings} set";
    gSetDI = "${gSet} org.gnome.desktop.interface";
    gsettings = "${glib}/gsettings";
    install = "${coreutils}/install";
    mkdir = "${coreutils}/mkdir";
    mktemp = "${coreutils}/mktemp";
    mv = "${coreutils}/mv";
    pkill = binaries.procps;
    rg = binaries.ripgrep;
    rm = "${coreutils}/rm";
  };
in {inherit tools bins;}
