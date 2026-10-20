_: let
  command = action: {
    kind = "exec";
    inherit action;
  };
  media = action: (command action) // {locked = true;};
  volume = direction:
    map (
      step:
        (media "dms ipc call audio ${direction} ${toString step}")
        // {repeating = true;}
    ) [5 1 10];
  brightness = direction:
    map (
      step:
        (media ''dms ipc call brightness ${direction} ${toString step} ""'')
        // {repeating = true;}
    ) [5 1 10];
in {
  ordered = {
    close = [
      (command "niri msg action close-window")
      (command "niri msg action quit")
      (command "dms ipc call powermenu toggle")
    ];
    lock = [
      (command "dms ipc call lock lock")
      (command "loginctl lock-session")
      (command "dms ipc call lock lock")
    ];
    launcher = [
      (command "dms ipc call spotlight toggle")
      (command "dms ipc call clipboard toggle")
      (command "dms ipc call spotlight toggleWith files")
    ];
    volumeUp = volume "increment";
    volumeDown = volume "decrement";
    volumeMute = [(media "dms ipc call audio mute")];
    brightnessUp = brightness "increment";
    brightnessDown = brightness "decrement";
    volume = volume "increment" ++ volume "decrement" ++ [(media "dms ipc call audio mute")];
    brightness = brightness "increment" ++ brightness "decrement";
  };
}
