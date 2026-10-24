{
  mkGroup,
  mkEntry,
  ...
}:
mkGroup {
  name = "typography";
  description = "Typography";
  default = true;
  features = [
    (mkEntry {
      userSettings = builtins.fromJSON ''
        {
          "editor.fontFamily": "'Lilex Nerd Font', 'Maple Mono NF', monospace",
          "editor.fontLigatures": true,
          "editor.fontSize": 18,
          "editor.fontWeight": 500,
          "editor.letterSpacing": 0,
          "editor.lineHeight": 2,
          "terminal.integrated.fontFamily": "'Maple Mono NF', 'Lilex Nerd Font', monospace",
          "terminal.integrated.fontLigatures.enabled": true,
          "terminal.integrated.fontSize": 18,
          "terminal.integrated.fontWeight": 500,
          "terminal.integrated.letterSpacing": 0,
          "terminal.integrated.lineHeight": 1.2
        }
      '';
    })
  ];
}
