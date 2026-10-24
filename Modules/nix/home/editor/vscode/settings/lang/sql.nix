{cfg, context, mkEnable, requires, ...}: let
  formatter = "adpyke.vscode-sql-formatter";
in {
  enable = cfg.sql.enable;
  options.sql.enable = mkEnable {
    inherit context;
    condition = requires ["sql" "sqlite"];
  };
  extensions = [
    "mtxr.sqltools"
    "mtxr.sqltools-driver-sqlite"
    formatter
  ];
  settings = {
    "[sql]"."editor.defaultFormatter" = formatter;
  };
}
