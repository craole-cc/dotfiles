{
  mkGroup,
  mkEntry,
  ...
} @ args: let
  decorations = import ./entries/decorations.nix args;
in
  mkGroup {
    name = "decorations";
    description = "Decorations";
    default = true;
    features =
      [ [
        (mkEntry {
          extensions = ["brandonkirbyson.vscode-animations"];
          userSettings = {
            "animations.Install-Method" = "Custom UI Style";
            "animations.CursorAnimation" = true;
            "animations.CursorAnimationOptions" = {
              Color = "teal";
              CursorStyle = "block";
              TrailLength = 8;
            };
          };
        })
        (mkEntry {
          extensions = [
            "subframe7536.custom-ui-style"
            "be5invis.vscode-custom-css"
            "illixion.vscode-vibrancy-continued"
          ];
          userSettings = with args.fonts.families; {
            "custom-ui-style.font.sansSerif" = sansSerif;
            "custom-ui-style.font.monospace" = monospace;
            "custom-ui-style.background.syncURL" = "file:///$\\{env:WALLPAPER\\}";
            "custom-ui-style.background.size" = "cover";
            "custom-ui-style.background.position" = "center";
            "custom-ui-style.background.opacity" = 0.94;
            "custom-ui-style.reloadWithoutPrompting" = true;
            "custom-ui-style.watch" = true;
          };
        })
      ];
  }
