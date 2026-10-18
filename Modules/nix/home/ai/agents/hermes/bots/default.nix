{
  cfg,
  common,
  config,
  lix,
  pkgs,
  ...
}: let
  inherit (lix.attrsets.transformation) filterAttrs mapAttrsToList;
  inherit (lix.options.construction) mkFalse mkOption;
  inherit (lix.strings.transformation) escapeShellArg;
  inherit (lix.types.combinators) submodule;
  inherit (lix.types.primitives) str;

  service = config.services.hermes-agent;
  active = filterAttrs (_name: profile: profile.enable && profile.bot.enable) cfg.profiles;
in {
  profileOptions = name: {
    bot = mkOption {
      type = submodule {
        options = {
          enable = mkFalse "Present this profile as a named Bot in Hermes Desktop.";
          title = mkOption {
            type = str;
            default = name;
            description = "Display name in the Hermes Bot roster.";
          };
        };
      };
      default = {};
      description = "Bot Mode presentation and a launcher for the profile's persistent Bot Chat.";
    };
  };

  metadata = _name: profile: {
    ui_meta.hermes-bots =
      if profile.bot.enable
      then {inherit (profile.bot) title;}
      else null;
  };

  outputs.home.packages = mapAttrsToList (name: _profile:
    pkgs.writeShellScriptBin "hermes-bot-${name}" ''
      export HERMES_HOME=${escapeShellArg service.hermesHome}
      exec ${common.effectivePackage service}/bin/hermes --profile ${escapeShellArg name} \
        chat -c "Bot Chat" --create-if-missing "$@"
    '')
  active;
}
