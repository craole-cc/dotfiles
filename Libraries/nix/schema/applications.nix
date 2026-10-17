{_, ...}: let
  inherit (_.applications.registry) resolve;
  inherit (_.attrsets.access) attrByPath attrValues;
  inherit (_.attrsets.aggregation) recursiveUpdate;
  inherit (_.attrsets.construction) optionalAttrs;
  inherit (_.attrsets.transformation) mapAttrs;
  inherit (_.lists.access) elemAt length;
  inherit (_.lists.aggregation) concatMap;
  inherit (_.lists.construction) toList;
  inherit (_.lists.selection) drop filter;
  inherit (_.lists.transformation) unique;
  inherit (_.types.predicates) isAttrs isString;
  inherit (_.debug.tracing) tryEval;
  inherit (_.strings.transformation) hasInfix toLower;

  __exports = {
    internal = {inherit defaults uiDefaults mkApplications;};
    external = {
      mkSchemaApplications = mkApplications;
    };
  };

  # ── Defaults ────────────────────────────────────────────────────────────────

  defaults = {
    browser = {
      primary = "zen-twilight";
      secondary = "chromium";
      tertiary = null;
    };
    terminal = {
      # Kitty is the protocol-neutral schema default. Users/hosts may provide
      # protocol-specific overrides such as `terminal.wayland.primary = "foot"`.
      primary = "kitty";
      secondary = "ghostty";
      tertiary = null;
    };
    editor = {
      tty = {
        primary = "helix";
        secondary = "neovim";
        tertiary = null;
      };
      gui = {
        primary = "vscode-fhs";
        secondary = "zed-editor-fhs";
        tertiary = null;
      };
    };
    launcher = {
      primary = "vicinae";
      secondary = null;
      tertiary = null;
    };
    explorer = {
      primary = "yazi";
      secondary = "doublecmd";
      tertiary = "nautilus";
    };
    ai = {
      primary = "chatgpt";
      secondary = "claude-desktop";
      tertiary = null;
    };
    bar = null;
    prompt = "starship";
    allowed = [];
  };

  uiDefaults = {
    launcher = {
      pri = "vicinae";
      sec = "vicinae";
    };
    terminal = {
      pri = "kitty";
      sec = "ghostty";
    };
    explorer = {
      pri = "doublecmd";
      sec = "yazi";
    };
    browser = {
      pri = "zen-twilight";
      sec = "chromium";
    };
    editor = {
      pri = "vscode";
      sec = "helix";
    };
  };

  # ── Command resolution ───────────────────────────────────────────────────────
  # Maps app names to the actual binary command to run.

  commandMap = {
    browser = {
      "zen-twilight" = "zen";
      "zen-beta" = "zen";
      "zen" = "zen";
      "chromium" = "chromium";
      "firefox" = "firefox";
      "brave" = "brave";
      "vivaldi" = "vivaldi";
      "floorp" = "floorp";
      "microsoft-edge" = "microsoft-edge";
      "google-chrome" = "google-chrome-stable";
    };
    terminal = {
      "foot" = "feet";
      "ghostty" = "ghostty";
      "kitty" = "kitty";
      "alacritty" = "alacritty";
      "wezterm" = "wezterm";
      "warp-terminal" = "warp-terminal";
      "rio" = "rio";
    };
    editor = {
      "helix" = "hx";
      "neovim" = "nvim";
      "nvim" = "nvim";
      "vscode" = "code";
      "vscode-fhs" = "code";
      "vscode-insiders" = "code-insiders";
      "code-insiders" = "code-insiders";
      "vscodium" = "codium";
      "zed" = "zeditor";
      "zed-editor-fhs" = "zeditor";
      "zeditor" = "zeditor";
      "vim" = "vim";
      "nano" = "nano";
      "emacs" = "emacs";
      "sublime" = "subl";
    };
    launcher = {
      "vicinae" = "vicinae toggle";
      "fuzzel" = "pkill fuzzel || fuzzel --list-executables-in-path";
      "wofi" = "wofi";
      "rofi" = "rofi";
      "tofi" = "tofi";
      "dmenu" = "dmenu";
      "ulauncher" = "ulauncher";
    };
    explorer = {
      "yazi" = "yazi";
      "doublecmd" = "doublecmd";
      "nautilus" = "org.gnome.Nautilus";
      "dolphin" = "dolphin";
      "thunar" = "thunar";
      "nemo" = "nemo";
    };
    bar = {
      "waybar" = "waybar";
      "caelestia" = "caelestia";
      "noctalia" = "noctalia";
      "ags" = "ags";
      "eww" = "eww";
      "yambar" = "yambar";
    };
  };

  # ── Class resolution ─────────────────────────────────────────────────────────

  classMap = {
    "zen" = "zen";
    "chromium" = "chromium";
    "firefox" = "firefox";
    "brave" = "brave";
    "vivaldi" = "vivaldi";
    "floorp" = "floorp";
    "microsoft-edge" = "microsoft-edge";
    "google-chrome-stable" = "google-chrome";
    "feet" = "foot";
    "ghostty" = "com.mitchellh.ghostty";
    "kitty" = "kitty";
    "alacritty" = "Alacritty";
    "wezterm" = "org.wezfurlong.wezterm";
    "warp-terminal" = "dev.warp.Warp";
    "hx" = "Helix";
    "nvim" = "nvim";
    "code" = "code";
    "code-insiders" = "code - Insiders";
    "codium" = "VSCodium";
    "zeditor" = "dev.zed.Zed";
    "vim" = "vim";
    "vicinae" = "vicinae";
    "fuzzel" = "fuzzel";
    "wofi" = "wofi";
    "rofi" = "rofi";
    "yazi" = "yazi";
    "doublecmd" = "doublecmd";
    "org.gnome.Nautilus" = "org.gnome.Nautilus";
    "dolphin" = "dolphin";
    "thunar" = "thunar";
  };

  legacyCommand = category: name: let
    n = toLower name;
  in
    attrByPath [category n] n commandMap;

  legacyClass = command: let
    n = toLower command;
  in
    if hasInfix "fuzzel" n
    then "fuzzel"
    else if hasInfix "vicinae" n
    then "vicinae"
    else if hasInfix "yazi" n
    then "yazi"
    else if hasInfix "ghostty" n
    then "com.mitchellh.ghostty"
    else if hasInfix "zeditor" n
    then "dev.zed.Zed"
    else if hasInfix "nautilus" n
    then "org.gnome.Nautilus"
    else classMap.${n} or n;

  getCommand = category: name:
    if category == "browser" || category == "ai"
    then
      (resolve {
        value = name;
        inherit category;
      }).exec
    else legacyCommand category name;

  registryCategory = category:
    if category == "explorer"
    then "explorer"
    else category;

  getMeta = category: name: let
    result = tryEval (resolve {
      value = name;
      category = registryCategory category;
    });
  in
    if result.success
    then result.value
    else {};

  getClass = category: name: let
    command = getCommand category name;
    meta = getMeta category name;
  in
    meta.names.class or (legacyClass command);

  scratchpadCommand = category: meta: command:
    if category == "browser"
    then "${command} --new-window about:blank"
    else if category == "editor" && (meta.family or null) == "vscode"
    then "${command} --new-window"
    else if category == "editor" && (meta.name or null) == "zed"
    then "${command} --new"
    else command;

  mkEntry = category: name: let
    meta = getMeta category name;
    command = getCommand category name;
  in {
    name = meta.name or name;
    inherit command;
    class = getClass category name;
    needsTerminal = meta.needsTerminal or false;
    wrap = meta.wrap or {};
    launch.scratchpad = scratchpadCommand category meta command;
  };

  # ── Resolution ───────────────────────────────────────────────────────────────

  mkApplications = {
    host,
    user ? {},
  }: let
    userProtocol = (user.interface or {}).displayProtocol or null;
    hostProtocol = (host.interface or {}).displayProtocol or null;
    protocol =
      if userProtocol != null
      then userProtocol
      else hostProtocol;

    ranks = ["primary" "secondary" "tertiary"];
    resolveProtocol = value:
      if isAttrs value
      then
        removeAttrs (recursiveUpdate value (
          if protocol != null
          then value.${protocol} or {}
          else {}
        )) ["wayland" "x11" "xorg"]
      else value;

    # Explicit legacy ranks precede the ordered tail; a string is one entry.
    normalizeSelection = value: let
      resolved = resolveProtocol value;
      entries =
        if isAttrs resolved
        then
          concatMap (rank: toList (resolved.${rank} or [])) ranks
          ++ toList (resolved.ordered or resolved.list or [])
        else toList resolved;
    in
      unique (filter (entry: isString entry && entry != "") entries);

    selection = values: {
      ordered = values;
      primary =
        if length values > 0
        then elemAt values 0
        else null;
      secondary =
        if length values > 1
        then elemAt values 1
        else null;
      tertiary =
        if length values > 2
        then elemAt values 2
        else null;
    };

    # Normalise each scope before merging. User preferences lead the host's
    # requirements. Only ranks explicitly declared in that scope move ahead
    # of a new packages list; schema defaults never displace that list.
    normalizeLegacy = previous: value: let
      resolved = resolveProtocol value;
    in
      normalizeSelection (
        if isAttrs resolved && !(resolved ? ordered || resolved ? list)
        then (selection previous) // {ordered = drop 3 previous;} // resolved
        else resolved
      );

    normalizePackage = previous: value:
      normalizeSelection (
        if isAttrs value && !(value ? ordered || value ? list)
        then value // {ordered = previous;}
        else value
      );

    getSelections = definition: previous: let
      legacy = definition.applications or {};
      packages = definition.packages or {};
      group = name: packageName: let
        old = legacy.${name} or null;
        current = packages.${packageName} or null;
        ranked =
          if isAttrs old
          then concatMap (rank: toList ((resolveProtocol old).${rank} or [])) ranks
          else [];
      in
        optionalAttrs (legacy ? ${name} || packages ? ${packageName}) {
          ${name} =
            if packages ? ${packageName}
            then normalizeSelection {ordered = ranked ++ normalizePackage previous.${name} current;}
            else normalizeLegacy previous.${name} old;
        };
      oldEditor = resolveProtocol (legacy.editor or {});
      editorGroup = kind: packageName: let
        old = oldEditor.${kind} or null;
        ranked =
          if isAttrs old
          then concatMap (rank: toList ((resolveProtocol old).${rank} or [])) ranks
          else [];
      in
        optionalAttrs (oldEditor ? ${kind} || packages ? ${packageName}) {
          ${kind} =
            if packages ? ${packageName}
            then normalizeSelection {ordered = ranked ++ normalizePackage previous.editor.${kind} packages.${packageName};}
            else normalizeLegacy previous.editor.${kind} old;
        };
    in
      group "terminal" "terminal"
      // group "browser" "browser"
      // group "launcher" "launcher"
      // group "explorer" "explorer"
      // group "ai" "ai-agent"
      // group "bar" "bar"
      // group "prompt" "prompt"
      // {editor = editorGroup "tty" "editor" // editorGroup "gui" "ide";};

    base =
      (mapAttrs (_: normalizeSelection) (removeAttrs defaults ["editor" "allowed"]))
      // {
        editor = mapAttrs (_: normalizeSelection) defaults.editor;
      };
    hostSelections = recursiveUpdate base (getSelections host base);
    userSelections = getSelections user hostSelections;
    preferred = recursiveUpdate hostSelections userSelections;
    # User order leads; explicit host requirements remain at the tail. Schema
    # defaults are fallbacks, so they are not appended to declared groups.
    required = getSelections host base;
    ordered =
      (mapAttrs (name: values: unique (values ++ (required.${name} or [])))
        (removeAttrs preferred ["editor"]))
      // {
        editor = mapAttrs (kind: values: unique (values ++ (required.editor.${kind} or []))) preferred.editor;
      };
    selected =
      concatMap (name: ordered.${name}) ["terminal" "browser" "launcher" "explorer" "ai" "bar" "prompt"]
      ++ ordered.editor.tty ++ ordered.editor.gui;
    extraGroups = definition:
      removeAttrs (definition.packages or {}) [
        "kernel"
        "core"
        "home"
        "allowUnsupportedSystem"
        "unstable"
        "allowUnfree"
        "allowBroken"
        "config"
        "overlays"
        "terminal"
        "browser"
        "editor"
        "ide"
        "explorer"
        "ai-agent"
        "launcher"
        "bar"
        "prompt"
      ];
    hostExtras = mapAttrs (_: normalizeSelection) (extraGroups host);
    requiredPackages = unique (
      concatMap (name: required.${name} or []) ["terminal" "browser" "launcher" "explorer" "ai" "bar" "prompt"]
      ++ (required.editor.tty or [])
      ++ (required.editor.gui or [])
      ++ concatMap normalizeSelection (attrValues (removeAttrs hostExtras ["coding"]))
    );
    extras =
      hostExtras
      // (mapAttrs (
        name: value:
          unique (normalizePackage (hostExtras.${name} or []) value ++ (hostExtras.${name} or []))
      ) (extraGroups user));
    packages =
      extras
      // {
        inherit (ordered) terminal browser launcher explorer bar prompt;
        ai-agent = ordered.ai;
        editor = ordered.editor.tty;
        ide = ordered.editor.gui;
      };
    requestedPackages = concatMap normalizeSelection (attrValues extras);
    raw =
      (mapAttrs (_: selection) (removeAttrs ordered ["editor" "bar" "prompt"]))
      // {
        editor = mapAttrs (_: selection) ordered.editor;
        bar = (selection ordered.bar).primary;
        prompt = (selection ordered.prompt).primary;
        allowed = unique (
          toList (host.applications.allowed or [])
          ++ toList (user.applications.allowed or [])
          ++ requestedPackages ++ selected
        );
      };
    enrich = category: values: let
      entries = map (mkEntry category) values;
    in
      selection entries;
  in {
    ai = enrich "ai" ordered.ai;
    browser = enrich "browser" ordered.browser;
    terminal = enrich "terminal" ordered.terminal;
    editor =
      (enrich "editor" ordered.editor.gui)
      // {
        tty = enrich "editor" ordered.editor.tty;
        gui = enrich "editor" ordered.editor.gui;
      };
    launcher = enrich "launcher" ordered.launcher;
    explorer = enrich "explorer" ordered.explorer;
    bar.primary = mkEntry "bar" (
      if raw.bar == null
      then "waybar"
      else raw.bar
    );
    inherit raw packages requiredPackages;
    inherit (raw) prompt allowed;
  };
in
  __exports.internal // {__rootAliases = __exports.external;}
