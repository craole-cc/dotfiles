{lix ? (import ../.. {}).libraries.default}: let
  inherit (lix.applications.editors) mkVSCodeFeature;
  inherit (builtins) all attrValues deepSeq tryEval;

  pkgs = {
    stdenv.hostPlatform.system = "x86_64-linux";
    vscode-extensions.example.present = "nixpkgs-extension";
  };
  inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.example = {
    present = "marketplace-duplicate";
    market = "marketplace-extension";
  };
  resolve = enabled: extensions:
    mkVSCodeFeature {inherit enabled extensions pkgs inputs;};
  succeeds = value: (tryEval (deepSeq value true)).success;

  checks = {
    nixpkgsTakesPriority =
      (resolve true ["example.present"]).extensions == ["nixpkgs-extension"];
    marketplaceFallback =
      (resolve true ["example.market"]).extensions == ["marketplace-extension"];
    structuredIdentifier =
      (resolve true [
        {
          publisher = "example";
          name = "present";
        }
      ]).extensions
      == ["nixpkgs-extension"];
    missingRequiredExtensionRejected =
      !(succeeds (resolve true ["example.missing"]).extensions);
    disabledMissingExtensionIgnored =
      (resolve false ["example.missing"]).extensions == [];
    disabledSettingsOmitted = !(resolve false [] ? userSettings);
    emptyFeatureAllowed = (resolve true []).extensions == [];
  };
in
  assert all (passed: passed) (attrValues checks); checks
