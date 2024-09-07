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

  hardware.graphics = {
    extraPackages = with pkgs; [
      amdvlk
      libvdpau-va-gl
      mesa
      vaapiVdpau
      vulkan-validation-layers
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
      driversi686Linux.mesa
    ];
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
  };

  environment.pathsToLink = [ "/libexec" ];

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
    virt-manager.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      pkgs.libusb1
      pkgs.cargo
      pkgs.rustc
      pkgs.pkg-config
      pkgs.cacert
    ];
  };

  environment.systemPackages = with pkgs; [
    alvr
    ddcutil
    i2c-tools
    lact
    (pkgs.python3.withPackages (ps: with ps; [tkinter]))
    sidequest
    tpm2-tss
  ];

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  hardware.i2c.enable = true;
  hardware.keyboard.qmk.enable = true;

  services.ddccontrol.enable = true;
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
  };
  services.hardware.openrgb.enable = true;


  console.useXkbConfig = true;

  networking.hostName = "Absolution";
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 5900 ];


  virtualisation.libvirtd = {
    enable = true;
    extraConfig = ''
      user="alyx"
    '';
    qemu.ovmf.enable = true;
    qemu.package = pkgs.qemu;
    qemu.ovmf.packages = [
      pkgs.OVMF.fd
      pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
    ];
    qemu.runAsRoot = true;
    qemu.swtpm.enable = true;
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  systemd.services.lactd = {
   after = [ "multi-user.target" ];
   description = "AMDGPU Control Daemon";
   wantedBy = [ "multi-user.target" ];
   serviceConfig = {
     ExecStart = ''${pkgs.lact}/bin/lact daemon'';
     Nice = "-10";
   };
  };

  services.input-remapper = {
    enable = true;
    enableUdevRules = true;
  };

  virtualisation.spiceUSBRedirection.enable = true;

  boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.initrd.systemd.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-partuuid/305d296d-74d4-4900-8450-da74668c898d";
      header = "/dev/disk/by-partuuid/5bfd9605-94ae-4813-9cd4-86b4974d47ab";
      allowDiscards = true;
      preLVM = true;
    };
  };

  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.supportedFilesystems = ["exfat" "xfs" "ntfs"];
  boot.kernelParams = [ "preempt=voluntary" "intel_iommu=on" "iommu=pt" "pcie_acs_override=downstream,multifunction"];
  boot.initrd.kernelModules = ["vfio_pci" "vfio_iommu_type1" "vfio" "kvm-intel"];
  boot.kernelModules = ["vfio_virqfd" "vhost-net"];
  #boot.extraModprobeConfig = "options vfio-pci ids=1b21:2142,10de:1c03,10de:10f1";
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  
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
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };
}
