{
  lix,
  cfg,
  tools,
  host,
  ...
}: let
  inherit (lix.options.construction) mkEnable mkOption;
  inherit (lix.modules.construction) mkIf;
  inherit (lix.lists.predicates) elem;
  inherit (lix.types.primitives) package;

  isGraphical =
    #TODO: Use isIn and check functionalities
    elem
    (host.type or (host.specs.machine or null))
    ["desktop" "laptop"];
in {
  options.app = {
    enable = mkEnable {
      description = ''
        Install the ChatGPT desktop app (it also runs Codex) alongside the CLI.
        Defaults to on when Codex is enabled and the host is a desktop or laptop.
      '';
      condition = cfg.enable && isGraphical;
    };

    package = mkOption {
      type = package;
      default = tools.chatgpt.package;
      description = "Desktop application for ChatGPT and Codex, from the flake inputs.";
    };
  };

  outputs = mkIf cfg.app.enable {home.packages = [cfg.app.package];};
}
