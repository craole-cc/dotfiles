{
  lix,
  json,
  cfg,
  defaults,
  overrides,
  ...
}: let
  inherit (lix.attrsets.access) attrNames;
  inherit (lix.modules.construction) mkMerge;
  inherit (lix.modules.evaluation) evalModules;
  inherit (lix.options.construction) mkOption;
  inherit (lix.types.combinators) listOf;
  inherit (lix.types.primitives) package;

  # Resolve the existing profile fragments through a small option module so
  # mkDefault/mkMerge semantics are preserved without making stable VS Code's
  # writable user configuration Home Manager-owned.
  profile =
    (evalModules {
      modules = [
        {
          options = {
            userSettings = mkOption {
              inherit (json) type;
              default = {}; # TODO: Should this not come from imports/defaults
            };
            keybindings = mkOption {
              type = listOf json.type;
              default = []; # TODO: Should this not come from imports/defaults
            };
            extensions = mkOption {
              type = listOf package;
              default = []; # TODO: Should this not come from imports/defaults
            };
          };
        }
        {
          config = mkMerge (
            [defaults]
            ++ ( # TODO: This maybe might be correct now but can be refactored
              map
              (name: overrides.settings.features.${name} cfg.withExtensions.${name})
              (attrNames overrides.settings.options)
            )
          );
        }
      ];
    }).config;
in
  profile
