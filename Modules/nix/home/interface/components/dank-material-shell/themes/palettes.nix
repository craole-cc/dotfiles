{ lix }:
let
  inherit (lix.attrsets.transformation) mapAttrs;
  inherit (lix.lists.transformation) imap0;
  inherit (lix.strings.construction) concatStringsSep;
  inherit (lix.strings.transformation) stripHash;

  mkTerminalPalette =
    input:
    let
      palette = input.palette or input;
      resolve = mapAttrs (_: color: palette.colors.${color} or color);
      regular = resolve palette.ansi.regular;
      bright = regular // resolve palette.ansi.bright;
      ordered =
        slots:
        map (slot: slots.${slot}) [
          "black"
          "red"
          "green"
          "yellow"
          "blue"
          "magenta"
          "cyan"
          "white"
        ];
    in
    {
      inherit (palette)
        name
        variant
        foreground
        background
        ;
      selectionBackground = palette.surface;
      cursor = palette.accent;
      regular = ordered regular;
      bright = ordered bright;
    };

  mkFootPalette =
    palette:
    let
      terminal = mkTerminalPalette palette;
    in
    ''
      # ${terminal.name}
      [colors-${terminal.variant}]
      foreground=${stripHash terminal.foreground}
      background=${stripHash terminal.background}
      selection-foreground=${stripHash terminal.foreground}
      selection-background=${stripHash terminal.selectionBackground}
      cursor=${stripHash terminal.background} ${stripHash terminal.cursor}

      ${concatStringsSep "\n" (
        (imap0 (index: color: "regular${toString index}=${stripHash color}") terminal.regular)
        ++ (imap0 (index: color: "bright${toString index}=${stripHash color}") terminal.bright)
      )}
    '';

  mkKittyPalette =
    palette:
    let
      terminal = mkTerminalPalette palette;
    in
    ''
      # ${terminal.name}
      foreground ${terminal.foreground}
      background ${terminal.background}
      selection_foreground ${terminal.foreground}
      selection_background ${terminal.selectionBackground}
      cursor ${terminal.cursor}

      ${concatStringsSep "\n" (
        imap0 (index: color: "color${toString index} ${color}") (terminal.regular ++ terminal.bright)
      )}
    '';

  mkGhosttyPalette =
    palette:
    let
      terminal = mkTerminalPalette palette;
    in
    ''
      # ${terminal.name}
      foreground = ${terminal.foreground}
      background = ${terminal.background}
      selection-foreground = ${terminal.foreground}
      selection-background = ${terminal.selectionBackground}
      cursor-color = ${terminal.cursor}
      ${concatStringsSep "\n" (
        imap0 (index: color: "palette = ${toString index}=${color}") (terminal.regular ++ terminal.bright)
      )}
    '';
in
{
  inherit
    mkTerminalPalette
    mkFootPalette
    mkKittyPalette
    mkGhosttyPalette
    ;
}
