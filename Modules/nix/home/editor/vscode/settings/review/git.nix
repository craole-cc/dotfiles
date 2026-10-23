{
  mkGroup,
  mkEntry,
  ...
} @ args: let
  vcs = import ./entries/vcs.nix args;
in
  mkGroup {
    name = "git";
    description = "Git";
    default = true;
    features =
      [
        (mkEntry {
          userSettings = builtins.fromJSON ''
            {
              "git.enabled": true,
              "git.autofetch": true,
              "git.autoStash": true,
              "git.enableSmartCommit": true,
              "git.openRepositoryInParentFolders": "always",
              "git.rebaseWhenSync": true,
              "git.allowForcePush": true,
              "git.confirmForcePush": false,
              "git.confirmSync": false,
              "git.ignoreRebaseWarning": true
            }
          '';
        })
      ]
      ++ map (entry:
        entry
        // {
          userSettings = {};
          keybindings = [];
        }) [
        vcs.entries.git
      ];
  }
