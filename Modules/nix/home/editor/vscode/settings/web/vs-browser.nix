_: {
  extensions = ["Phu1237.vs-browser"];
  settings = {
    vs-browser = {
      favourites.list = {
        "http://127.0.0.1:3000" = "http://127.0.0.1:3000";
        "http://localhost" = "http://localhost";
      };
      link = {
        enabled = true;
        openWith = "ask";
      };
      localProxyServer = {
        cookieDomainRewrite = true;
        enabled = true;
        forceLocation = true;
      };
      reload = {
        autoReloadDurationEnabled = false;
        autoReloadDurationTime = 15000;
        onSave = false;
      };
      url = "http://127.0.0.1:3000";
    };
  };
}
