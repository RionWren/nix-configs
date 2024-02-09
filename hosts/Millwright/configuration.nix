{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      vulkan-validation-layers
      libvdpau-va-gl
      vaapiVdpau
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  services.xserver = {
    videoDrivers = ["amdgpu"];
  };

  hardware.enableAllFirmware = true;

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ddcutil
    i2c-tools
    (pkgs.python3.withPackages (ps: with ps; [tkinter]))
    tpm2-tss
    virt-manager
  ];

  hardware.i2c.enable = true;

  services.ddccontrol.enable = true;
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
  };

  console.useXkbConfig = true;

  networking.hostName = "Millwright";

  virtualisation.libvirtd = {
    enable = true;
    extraConfig = ''
      user="alyx"
    '';
    qemu.ovmf.enable = true;
    qemu.package = pkgs.qemu_kvm;
    qemu.runAsRoot = true;
    qemu.swtpm.enable = true;
  };

  virtualisation.spiceUSBRedirection.enable = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.bootspec.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-18d0700e-1d6a-4526-83f6-4b0053b1a935".device = "/dev/disk/by-uuid/18d0700e-1d6a-4526-83f6-4b0053b1a935";
  boot.initrd.systemd.enable = true;
  boot.supportedFilesystems = ["exfat" "xfs" "ntfs"];
  boot.kernelParams = ["preempt=voluntary" "module_blacklist=nouveau" "intel_iommu=on" "iommu=pt" "pcie_acs_override=downstream,multifunction"];
  boot.initrd.kernelModules = ["vfio_pci" "vfio_iommu_type1" "vfio" "kvm-intel"];
  boot.kernelModules = ["vfio_virqfd" "vhost-net"];
  boot.extraModprobeConfig = "options vfio-pci ids=10de:1c03,10de:10f1,1b21:2142";
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.blacklistedKernelModules = ["nouveau"];

  # enable networking
  networking.networkmanager.wifi.backend = "iwd";

  # Set a time zone
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "it_IT.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  users.users.alyx = {
    isNormalUser = true;
    description = "alyx";
    extraGroups = ["networkmanager" "wheel" "adbusers" "libvirtd" "kvm"];
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
  };

  services.pipewire = {
    extraConfig = {
      pipewire = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.rate" = 96000;
          };
        };
      };
      pipewire-pulse = {
        "11-pulse-clock-rate" = {
          "pulse.properties" = {
            "pulse.default.req" = "128/96000";
          };
        };
      };
    };
  };

  services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };
}
