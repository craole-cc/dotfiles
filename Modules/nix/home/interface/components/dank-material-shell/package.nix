package:
package.overrideAttrs (previous: {
  # sourceRoot is core; patch the Go backend and QML before make sync-shell
  # embeds the frontend into the executable.
  postPatch =
    (previous.postPatch or "")
    + ''
        chmod -R u+w ../quickshell
      patch -d .. -p1 < ${./patches/theme-control.patch}
    '';
})
