{
  config,
  host,
  lix,
  pkgs,
  ...
}: let
  context = mkContext {
    inherit config;
    dom = "hardware";
    mod = "boot";
  };
  inherit (context) cfg mod;
  inherit (lix.lists.access) length;
  inherit (lix.lists.enums.gui) bootLoaders;
  inherit (lix.attrsets.predicates) hasAttr;
  inherit (lix.lists.predicates) any elem;
  inherit (lix.lists.transformation) filter;
  inherit (lix.modules.construction) mkConfig mkContext mkIf;
  inherit (lix.options.construction) mkTrue mkOption;
  inherit (lix.strings.construction) concatStringsSep optionalString;
  inherit (lix.strings.predicates) hasInfix hasPrefix isString;
  inherit (lix.strings.transformation) toLowerCase;
  inherit (lix.types.combinators) enum;
  inherit (lix.types.primitives) int str;

  hw = host.hardware;
  isX86 = pkgs.stdenv.hostPlatform.isx86;

  validPatterns = [
    "system"
    "refind"
    "grub"
    "limine"
  ];

  kernel = lix.schema.kernel.resolve {
    inherit host pkgs;
    user = host.users.data.primary or {};
  };
  bareCachyOS =
    kernel.requested != null
    && elem (toLowerCase kernel.requested) ["cachy" "cachyos" "linux-cachyos"];
  useGenericV3 =
    bareCachyOS
    && kernel.cpu.arch == "x86_64"
    && elem (toLowerCase (kernel.cpu.microarch or "")) ["znver1" "znver2" "znver3"]
    && kernel.level == "v1"
    && hasAttr "cachyOverride" kernel.packages;
  kernelPackages =
    if useGenericV3
    then
      kernel.packages.cachyOverride {
        cachyVars = kernel.packages.kernel.cachyConfig.cachyVars // {
          "_processor_opt" = "GENERIC_V3";
        };
      }
    else kernel.packages;
  kernelWarnings = if useGenericV3 then [] else kernel.warnings;

  isSystemd = hasInfix "system" cfg.loader;
  isRefind = hasInfix "refind" cfg.loader;
  isGrub = hasInfix "grub" cfg.loader;
  isLimine = hasInfix "limine" cfg.loader;

  selectedCount = length (filter (x: x) [
    isSystemd
    isRefind
    isGrub
    isLimine
  ]);
in
  mkConfig {
    inherit context;
    options = {
      enable = mkTrue mod;
      loader = mkOption {
        description = "Boot loader";
        default = hw.boot.loader;
        type = enum bootLoaders.values;
      };
      timeout = mkOption {
        description = "Boot loader timeout";
        default = hw.boot.timeout;
        type = int;
      };
      efiMount = mkOption {
        description = "EFI mount point";
        default = hw.boot.efiMount;
        type = str;
      };
    };
    outputs = {
      warnings = kernelWarnings;
      assertions = [
        {
          assertion = any (pattern: hasInfix pattern cfg.loader) validPatterns;
          message = ''
            Invalid bootLoader '${cfg.loader}'.
            Must contain one of: ${concatStringsSep ", " validPatterns}
          '';
        }
        {
          assertion = hw.hasEfi;
          message = ''Boot loader requires EFI. Add "efi" to host.functionalities.'';
        }
        {
          assertion = cfg.timeout >= 0;
          message = "bootLoaderTimeout must be non-negative, got: ${toString cfg.timeout}";
        }
        {
          assertion = isString cfg.efiMount && hasPrefix "/" cfg.efiMount;
          message = "efiSysMountPoint must be an absolute path, got: ${toString cfg.efiMount}";
        }
        {
          assertion = selectedCount == 1;
          message = ''
            Exactly one boot loader must be selected, but '${cfg.loader}' matches ${toString selectedCount}.
            Valid loaders: ${concatStringsSep ", " validPatterns}
          '';
        }
      ];

      boot = {
        kernelPackages = kernelPackages;

        loader = {
          systemd-boot = mkIf isSystemd {
            enable = true;
            configurationLimit = 20;
            editor = false;
            memtest86.enable = isX86;
            netbootxyz.enable = isX86;
            rebootForBitlocker = true;
          };

          refind = mkIf isRefind {
            enable = true;
            extraConfig = ''
              timeout ${toString cfg.timeout}
              use_graphics_for linux
              scanfor manual,external,optical,netboot
              resolution 1600 900
              use_nvram false
              ${optionalString hw.hasDualBoot ''
                menuentry "Windows" {
                  loader \EFI\Microsoft\Boot\bootmgfw.efi
                  icon \EFI\refind\icons\os_win.png
                }
              ''}
            '';
          };

          grub = mkIf isGrub {
            enable = true;
            device = "nodev";
            efiSupport = hw.hasEfi;
            useOSProber = hw.hasDualBoot;
          };

          limine = mkIf isLimine {
            enable = true;
            efiSupport = hw.hasEfi;
            enableEditor = false;
            maxGenerations = 20;
            #? Windows must share this ESP for boot():/ to resolve. If it has its
            #? own ESP, swap boot() for guid(<partition-guid>) from `blkid`.
            extraEntries = optionalString hw.hasDualBoot ''
              /Windows
                  protocol: efi
                  path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
            '';
          };

          efi = {
            canTouchEfiVariables = hw.hasEfi;
            efiSysMountPoint = cfg.efiMount;
          };

          inherit (cfg) timeout;
        };

        initrd.availableKernelModules = host.hardware.kernelModules or (host.modules or []);
      };

      environment.systemPackages = with pkgs; [efibootmgr];
    };
  }
