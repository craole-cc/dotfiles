pkgs: let
  inherit (pkgs) curl gpu-screen-recorder;
  inherit (pkgs.qt6) qtimageformats;
in {
  plugins = {
    audioSwitcher.enable = true;
    volumeMixer.enable = true;
    screenRecorder.enable = true;
    dankGifSearch.enable = true;
    dankStickerSearch.enable = true;
  };

  packages = [curl gpu-screen-recorder qtimageformats];
}
