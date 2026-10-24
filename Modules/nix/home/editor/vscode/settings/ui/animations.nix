{fonts, ...}: {
  name = "animations";
  description = "Animations";
  extensions = [
    "brandonkirbyson.vscode-animations"
    "subframe7536.custom-ui-style"
    "be5invis.vscode-custom-css"
    #> Verify on Linux: vibrancy is only supported on Windows and macOS, as far as I know
    "illixion.vscode-vibrancy-continued"
  ];
  keybindings = [];

  settings = {
    #~@ Animations
    animations = {
      #> Install method used to inject the animations.
      #? Relies on the Custom UI Style extension, so it needs a writable VS Code install.
      Install-Method = "Custom UI Style";

      CursorAnimation = true;

      #> Object-valued setting: keep as a real attrset, do not flatten
      CursorAnimationOptions = {
        Color = "teal";
        CursorStyle = "block";
        TrailLength = 8;
      };
    };

    #~@ Custom UI Style
    custom-ui-style = {
      font = {inherit (fonts.families) sansSerif monospace;};

      background = {
        #> Wallpaper loaded from the WALLPAPER environment variable
        #? Must be set in the environment VS Code launches from, which a desktop launcher may not inherit from your shell.
        syncURL = "file:///\${env:WALLPAPER}";
        size = "cover";
        position = "center";
        opacity = 0.94;
      };

      reloadWithoutPrompting = true;
      watch = true;
    };
  };
}
