{
  lix,
  pkgs,
  ...
}: {
  imports = (lix.filesystem.traversal.importAllPaths ./.).value;
  home.packages = with pkgs; [
    # karere
    gImageReader
    # inkscape
    qbittorrent-enhanced
    yt-dlp
    # (spacedrive.overrideAttrs (oldAttrs: {
    #   makeWrapperArgs = [
    #     "--set GDK_BACKEND x11"
    #     "--add-flags '--disable-gpu'"
    #     "--add-flags '--disable-gpu-compositing'"
    #   ];``
    # }))

    swaybg
  ];
}
