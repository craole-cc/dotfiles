_: {
  extensions = [
    #? Material Design Icons for VS Code
    "PKief.material-icon-theme"
    #? Element Plus style product icon theme
    "eliverlara.andromeda"
  ];

  settings = {
    #> Active file icon theme.
    #! overridden (default: "vs-seti")
    "workbench.iconTheme" = "material-icon-theme";
    #> Active product icon theme.
    #! overridden (default: "Default")
    "workbench.productIconTheme" = "el-vsc-v1-icons";

    # ── material-icon-theme ─────────────────────────────────────────────
    #> Active icon pack.
    #?  - angular | angular_ngrx | react | react_redux | roblox | qwik
    #?  - vue | vue_vuex | nest | bashly | none
    #! overridden (default: "angular")
    "material-icon-theme.activeIconPack" = "react";
    #> Hide explorer arrows before folder.
    #! overridden (default: false)
    "material-icon-theme.hidesExplorerArrows" = true;
    #> File icon colour.
    #! overridden (default: "#90a4ae")
    "material-icon-theme.files.color" = "#e8ddd8";
    #> Folder icon colour.
    #! overridden (default: "#90a4ae")
    "material-icon-theme.folders.color" = "#81c8be";
    #> Folder icon theme.
    #?  - specific | classic | none
    "material-icon-theme.folders.theme" = "specific";
    #> Icon opacity (0–1).
    "material-icon-theme.opacity" = 1;
    #> Icon saturation (0–1).
    "material-icon-theme.saturation" = 1;
    #> Enable logging to the output channel.
    "material-icon-theme.enableLogging" = false;
    #> Log level.
    "material-icon-theme.logLevel" = "info";
    #> Custom file icon associations.
    "material-icon-theme.files.associations" = {};
    #> Custom folder icon associations.
    "material-icon-theme.folders.associations" = {};
    #> Custom root-folder associations.
    "material-icon-theme.rootFolders.associations" = {};
    #> Custom root-folder colour.
    "material-icon-theme.rootFolders.color" = "#90a4ae";
    #> Custom language associations.
    "material-icon-theme.languages.associations" = {};
    #> Custom icon clones.
    #?  Files, folders, languages, and root-folders all support this key.
    "material-icon-theme.files.customClones" = [];
    "material-icon-theme.folders.customClones" = [];
    "material-icon-theme.languages.customClones" = [];
  };
}
