{
  top,
  apps,
  lix,
  ...
}: let
  inherit (lix.attrsets.access) foldlAttrs;
  inherit (lix.lists.construction) concatLists;
  inherit (lix.lists.access) elemAt last;
  inherit (lix.lists.aggregation) foldl';
  inherit (lix.lists.predicates) all;
  inherit (lix.lists.transformation) imap0;
  inherit (lix.options.construction) mkOption mkOptionType;
  inherit (lix.types.primitives) anything;
  inherit (lix.types.predicates) isAttrs isList;
  inherit (lix.attrsets.construction) optionalAttrs;
  inherit (lix.modules.construction) mkDefault;

  mkSelectionVariables = prefix: entries:
    foldl' (variables: entry: variables // entry) {} (imap0 (index: entry:
      optionalAttrs ((entry.command or null) != null) (
        {
          "${prefix}_${toString (index + 1)}" = mkDefault entry.command;
          "${prefix}_${toString (index + 1)}_NAME" = mkDefault entry.name;
        }
        // optionalAttrs (index < 3) (let
          suffix = elemAt ["PRI" "SEC" "TER"] index;
        in {
          "${prefix}_${suffix}" = mkDefault entry.command;
          "${prefix}_${suffix}_NAME" = mkDefault entry.name;
        })
      ))
    entries);

  mkDefaultVariable = name: entries:
    optionalAttrs (entries != []) {${name} = mkDefault (elemAt entries 0).command;};
  primaryVariables =
    mkDefaultVariable "TERMINAL" apps.terminal
    // mkDefaultVariable "BROWSER" apps.browser
    // mkDefaultVariable "EDITOR" apps.editor
    // mkDefaultVariable "VISUAL" apps.ide
    // mkDefaultVariable "FILE_MANAGER" apps.explorer;

  mergeOutput = values:
    if all isAttrs values
    then
      foldl' (
        merged: value:
          foldlAttrs (
            result: name: item:
              result
              // {
                ${name} =
                  if result ? ${name}
                  then
                    mergeOutput [
                      result.${name}
                      item
                    ]
                  else item;
              }
          )
          merged
          value
      ) {}
      values
    else if all isList values
    then concatLists values
    else last values;

  outputType = mkOptionType {
    name = "home output";
    description = "recursively merged Home Manager output";
    check = _: true;
    merge = _: definitions: mergeOutput (map (definition: definition.value) definitions);
  };
in {
  options.${top} = {
    defaults = mkOption {
      description = "Schema-derived default dotDots input values";
      default = {};
      type = anything;
    };
    updates = mkOption {
      description = "Sparse dotDots input values differing from defaults";
      default = {};
      type = anything;
    };
    outputs = mkOption {
      description = "Sparse effective Home Manager configuration outputs";
      default = {};
      type = outputType;
    };
  };

  # Every selection receives an indexed variable. Named role suffixes remain
  # aliases for the first three entries during migration.
  config.home.sessionVariables =
    primaryVariables
    // (mkSelectionVariables "TERMINAL" apps.terminal)
    // (mkSelectionVariables "BROWSER" apps.browser)
    // (mkSelectionVariables "EDITOR" apps.editor)
    // (mkSelectionVariables "VISUAL" apps.ide)
    // (mkSelectionVariables "FILE_MANAGER" apps.explorer);

  imports = (lix.filesystem.traversal.importAllPaths ./.).value;

  # # Home is being migrated incrementally to the same mkContext/mkConfig
  # # contract as Core. Only migrated modules are wired here; the legacy tree
  # # remains available for staged conversion without participating in eval.
  # imports = [
  #   # ./ai/runtime.nix
  #   # ./applications
  #   ./interface/options.nix
  #   ./interface/catppuccin.nix
  #   ./interface/dms.nix
  #   ./interface/manager/hyprland

  #   # Browsers
  #   ./browser/chromium
  #   ./browser/zen

  #   # Editors
  #   ./editor/helix
  #   ./editor/nvim
  #   ./editor/vim
  #   ./editor/vscode
  #   ./editor/zeditor

  #   # Information utilities
  #   ./info/btop.nix
  #   ./info/clock.nix
  #   ./info/fetchers.nix

  #   # Media
  #   ./media/editing
  #   ./media/freetube
  #   ./media/mpv
  #   ./media/obs

  #   # Shells
  #   ./shells/core/bash
  #   ./shells/core/fish
  #   ./shells/core/nushell
  #   ./shells/core/zsh
  #   ./shells/prompt/starship.nix

  #   # Shell tools
  #   ./shells/tools/atuin.nix
  #   ./shells/tools/bat.nix
  #   ./shells/tools/direnv.nix
  #   ./shells/tools/grep.nix
  #   ./shells/tools/home-manager.nix
  #   ./shells/tools/nh.nix
  #   ./shells/tools/nix-index.nix
  #   ./shells/tools/topgrade.nix
  #   ./shells/tools/yazi.nix

  #   # Terminals
  #   ./terminal/core/foot
  #   ./terminal/core/ghostty
  #   ./terminal/core/kitty
  #   ./terminal/tools/tmux

  #   # Version control
  #   ./version-control/core/git.nix
  #   ./version-control/core/jujutsu.nix
  #   ./version-control/clients/github.nix
  #   ./version-control/clients/gitui.nix
  #   ./version-control/tools/delta.nix
  # ];
}
