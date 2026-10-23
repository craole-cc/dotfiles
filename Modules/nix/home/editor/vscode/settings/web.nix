{
  inputs,
  mkMerge,
  flatten,
  mkVSCodeFeature,
  mkVSCodeSubFeature,
  pkgs,
  ...
}: let
  tailwind = mkVSCodeSubFeature {
    enabled = true;
    extensions = [
      #? Tailwind CSS intellisense
      "bradlc.vscode-tailwindcss"
    ];
    userSettings = {
      "tailwindCSS.includeLanguages"."plaintext" = "html";
      "cssvar.files" = [
        "./node_modules/open-props/open-props.min.css"
        "assets/styles/variables.css"
        "style.css"
      ];
      "cssvar.extensions" = [
        "css"
        "postcss"
        "jsx"
        "tsx"
      ];
      "cssvar.ignore" = [];
    };
  };

  deno = mkVSCodeSubFeature {
    enabled = true;
    extensions = [
      #? Deno runtime and LSP
      "denoland.vscode-deno"
    ];
    userSettings = {
      "[javascript]"."editor.defaultFormatter" = "biomejs.biome";
      "[typescript]"."editor.defaultFormatter" = "denoland.vscode-deno";
      "[html]"."editor.defaultFormatter" = "biomejs.biome";
      "typescript.inlayHints.parameterNames.enabled" = "all";
    };
  };

  prettier = mkVSCodeSubFeature {
    enabled = true;
    extensions = [
      #? Prettier formatter
      "esbenp.prettier-vscode"
    ];
    userSettings = {
      "[css]"."editor.defaultFormatter" = "biomejs.biome";
      "[json]"."editor.defaultFormatter" = "vscode.json-language-features";
      "[jsonc]"."editor.defaultFormatter" = "vscode.json-language-features";
      "[scss]"."editor.defaultFormatter" = "biomejs.biome";
    };
  };
in {
  name = "web";
  description = "Web development extensions";
  default = true;
  feature = enabled:
    mkVSCodeFeature {
      inherit enabled pkgs inputs;
      extensions = flatten [
        tailwind.extensions
        deno.extensions
        prettier.extensions
      ];
      userSettings = mkMerge [
        (tailwind.userSettings or {})
        (deno.userSettings or {})
        (prettier.userSettings or {})
      ];
    };
}
