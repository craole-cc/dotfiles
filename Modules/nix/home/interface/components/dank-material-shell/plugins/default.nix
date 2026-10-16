{
  bins,
  config,
  inputs,
  lix,
  pkgs,
}: let
  inherit (lix.attrsets.construction) genAttrs optionalAttrs;
  inherit (lix.modules.construction) mkForce;

  chat = import ./packages.nix {inherit inputs pkgs;};
  selected = [
    # Chat Manager hosts the WhatsApp bridge.
    "chatManager"
    "whatsappChat"

    # Official Dank plugins from the pinned registry.
    "dankActions"
    "dankClight"
    "dankDesktopWeather"
    "dankGifSearch"
    "dankHooks"
    "dankHyprlandWindows"
    "dankKDEConnect"
    "dankLauncherKeys"
    "dankNotepadModule"
    "dankPomodoroTimer"
    "dankStickerSearch"
  ];
in {
  plugins = genAttrs selected (name:
    {enable = true;}
    // optionalAttrs (chat ? ${name}) {src = mkForce chat.${name};});

  packages = with pkgs; [clight curl go qt6.qtimageformats];
  activation = import ./activation.nix {inherit bins config inputs lix pkgs;};
}
