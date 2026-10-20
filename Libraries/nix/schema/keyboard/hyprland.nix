{
  _,
  terminals ? [],
}: let
  inherit (_.lists.access) elemAt length;
  inherit (_.lists.construction) genList;
  native = action: {
    kind = "hyprland";
    inherit action;
  };
  command = action: {
    kind = "exec";
    inherit action;
  };
  fullscreen = native ''window.fullscreen({ mode = "fullscreen", action = "toggle" })'';
  floating = native ''window.float({ action = "toggle" })'';
  groupLock = native ''group.lock_active({ action = "toggle" })'';

  navigation = direction: workspace: [
    (native ''focus({ direction = "${direction}" })'')
    (native ''window.move({ direction = "${direction}" })'')
    (native ''focus({ workspace = "${workspace}" })'')
  ];
in {
  # Hyprland-native actions do not depend on DMS being installed.
  legacy = {
    close = native "window.close()";
    inherit fullscreen;
    maximise = native ''window.fullscreen({ mode = "maximized", action = "toggle" })'';
    float = floating;
    pin = native ''window.pin({ action = "toggle" })'';
    split = native ''layout("togglesplit")'';
    pseudo = native ''window.pseudo({ action = "toggle" })'';
    groupToggle = native "group.toggle()";
    inherit groupLock;
    workspacePrev = native ''focus({ workspace = "previous" })'';
    windowCycle = native ''focus({ last = true })'';
    logout = native "exit()";
  };

  # Ordered groups are enabled only when a host or user declares their chords.
  # DMS-specific positions are supplied by dms/hyprland.nix when that panel is selected.
  ordered = {
    terminalOpen = genList (index: command (elemAt terminals index).command) (
      if length terminals < 2
      then length terminals
      else 2
    );
    close = [
      (native "window.close()")
      (native "exit()")
    ];
    window = [fullscreen floating];
    lock = [
      (command "loginctl lock-session")
      groupLock
    ];
    launcher = [];
    workspaceNext = navigation "r" "e+1";
    workspacePrev = navigation "l" "e-1";
    wallpaper = [
      (command "varietyctl next")
      (command "varietyctl previous")
      (command "varietyctl preferences")
      (command "varietyctl love")
    ];
    volumeUp = [];
    volumeDown = [];
    volumeMute = [];
    brightnessUp = [];
    brightnessDown = [];
  };
}
