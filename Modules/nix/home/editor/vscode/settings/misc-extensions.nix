{
  mkGroup,
  mkEntry,
  ...
} @ args: let
  infrastructure = import ./entries/infrastructure.nix args;
  markup = import ./entries/markup.nix args;
  productivity = import ./entries/productivity.nix args;
  vcs = import ./entries/vcs.nix args;
in
  mkGroup {
    name = "misc-extensions";
    description = "Misc Extensions";
    default = true;
    features =
      [
        (mkEntry {
          userSettings = builtins.fromJSON ''
            {
              "vs-browser.favourites.list": {
                "http://127.0.0.1:3000": "http://127.0.0.1:3000",
                "http://localhost": "http://localhost"
              },
              "vs-browser.link.enabled": true,
              "vs-browser.link.openWith": "ask",
              "vs-browser.localProxyServer.cookieDomainRewrite": true,
              "vs-browser.localProxyServer.enabled": true,
              "vs-browser.localProxyServer.forceLocation": true,
              "vs-browser.reload.autoReloadDurationEnabled": false,
              "vs-browser.reload.autoReloadDurationTime": 15000,
              "vs-browser.reload.onSave": false,
              "vs-browser.url": "http://127.0.0.1:3000",
              "rss.accounts": {
                "fb0e47b0-9982-11ef-a698-3778cde2492f": {
                  "name": "Default",
                  "type": "local",
                  "feeds": []
                }
              },
              "spreadjs.ribbonMode": "toolbar"
            }
          '';
          # Merged from keybindings.jsonc: EXTENSIONS
          keybindings = builtins.fromJSON ''
            [
              {
                "key": "ctrl+alt+.",
                "command": "extension.toggleFiles"
              }
            ]
          '';
        })
      ]
      ++ map (entry:
        entry
        // {
          userSettings = {};
          keybindings = [];
        }) [
        infrastructure.entries.docker
        markup.entries.tooling
        productivity.entries.text
        productivity.entries.license
        productivity.entries.runners
        productivity.entries.feeds
        productivity.entries.spreadsheets
        productivity.entries.integrations
        vcs.entries.jujutsu
      ];
  }
