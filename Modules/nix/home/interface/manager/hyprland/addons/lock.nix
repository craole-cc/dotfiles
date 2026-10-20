{config, lix, ...}: let
  inherit (lix.modules.construction) mkDefault;
in {
  hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = mkDefault [
        {
          # Variety updates this link; the controller never edits locker config.
          path = "${config.xdg.stateHome}/varietyctl/lockscreen";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = mkDefault [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "Password...";
          shadow_passes = 2;
        }
      ];
    };
  };
}
