_: {
  enable = false;
  extensions = [
    #? alternative AI completions
    "codeium.codeium"
  ];
  settings = {
    "codeium.disableSupercomplete" = true;
    "codeium.enableSearch" = true;
    "codeium.enableConfig" = {
      "*" = true;
      "nix" = true;
      "jsonc" = true;
      "just" = true;
      "markdown" = true;
      "typst" = true;
      "cypher" = true;
    };
  };
}
