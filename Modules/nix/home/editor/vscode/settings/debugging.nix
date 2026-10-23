{
  mkGroup,
  mkEntry,
  ...
} @ args: let
in
  mkGroup {
    name = "debugging";
    description = "Debugging";
    default = true;
    features = [
      (mkEntry {
        userSettings = builtins.fromJSON ''
          {
            "lldb.consoleMode": "commands",
            "lldb.dereferencePointers": true,
            "lldb.showDisassembly": "auto",
            "lldb.suppressUpdateNotifications": true
          }
        '';
      })
    ];
  }
