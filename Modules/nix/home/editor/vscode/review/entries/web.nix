{
  mkGroup,
  mkEntry,
  ...
}: let
  tailwind = mkEntry {
    enable = true;
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

  deno = mkEntry {
    enable = true;
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

  prettier = mkEntry {
    enable = true;
    extensions = [
      #? Prettier formatter
      "esbenp.prettier-vscode"
      #? Biome formatter selected by the language settings below
      "biomejs.biome"
    ];
    userSettings = {
      "[css]"."editor.defaultFormatter" = "biomejs.biome";
      "[json]"."editor.defaultFormatter" = "vscode.json-language-features";
      "[jsonc]"."editor.defaultFormatter" = "vscode.json-language-features";
      "[scss]"."editor.defaultFormatter" = "biomejs.biome";
    };
  };

  browser = mkEntry {
    enable = true;
    extensions = ["phu1237.vs-browser"];
    userSettings = {
      "vs-browser.favourites.list" = {
        "http://127.0.0.1:3000" = "http://127.0.0.1:3000";
        "http://localhost" = "http://localhost";
      };
      "vs-browser.link.enabled" = true;
      "vs-browser.link.openWith" = "ask";
      "vs-browser.localProxyServer.cookieDomainRewrite" = true;
      "vs-browser.localProxyServer.enabled" = true;
      "vs-browser.localProxyServer.forceLocation" = true;
      "vs-browser.reload.autoReloadDurationEnabled" = false;
      "vs-browser.reload.autoReloadDurationTime" = 15000;
      "vs-browser.reload.onSave" = false;
      "vs-browser.url" = "http://127.0.0.1:3000";
    };
  };
in {entries = {inherit tailwind deno prettier browser;};}
