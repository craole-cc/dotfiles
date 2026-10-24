_: {
  enable = false;
  extensions = [
    #? alternative AI completions
    "codeium.codeium"
  ];
  settings = {
    codeium = {
      disableSupercomplete = true;
      enableSearch = true;
      enableConfig = {
        "*" = true;
        "nix" = true;
        "jsonc" = true;
        "just" = true;
        "markdown" = true;
        "typst" = true;
        "cypher" = true;
      };
    };
  };
}
