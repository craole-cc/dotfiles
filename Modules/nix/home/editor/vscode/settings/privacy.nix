{
  mkGroup,
  mkEntry,
  ...
} @ args: let
in
  mkGroup {
    name = "privacy-telemetry";
    description = "Privacy & Telemetry";
    default = true;
    features = [
      (mkEntry {
        userSettings = builtins.fromJSON ''
          {
            "continue.telemetryEnabled": false,
            "redhat.telemetry.enabled": false
          }
        '';
      })
    ];
  }
