# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];
  
  hardware.graphics.extraPackages = with pkgs; [
    vulkan-validation-layers
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
    vaapiIntel
    nvidia-vaapi-driver
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  services.xserver = {
    videoDrivers = [ "nvidia" "i915" ];
    xkb.variant = lib.mkForce "colemak";
    xkb.layout = lib.mkForce "us";
  };

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
      };
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # the configuration (pain)
  programs = {
    adb.enable = true;
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    easyeffects
    i2c-tools
    krita
    (pkgs.python3.withPackages (ps: with ps; [tkinter]))
    tpm2-tss
    virt-manager
    vulkan-extension-layer
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
  ];

  services.fprintd.enable = true;

  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  networking.hostName = "Nomad";

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    extraConfig = ''
      user="alyx"
    '';
    qemu.ovmf.enable = true;
    qemu.package = pkgs.qemu_kvm;
    qemu.runAsRoot = true;
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.bootspec.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.extraModprobeConfig = "options nvidia_drm fbdev=1";

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-partuuid/93b4aa33-98ae-4b04-9f2c-34a10793e303";
      allowDiscards = true;
      preLVM = true;
    };
  };

  # Set a time zone, idiot
  time.timeZone = "Europe/London";

  # Fun internationalisation stuffs (AAAAAAAA)
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

  # define user acc
  users.users.alyx = {
    isNormalUser = true;
    description = "alyx";
    extraGroups = ["networkmanager" "wheel" "adbusers" "libvirtd"];
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.

  services.openssh.enable = false;
  services.openssh.settings = {
    # Forbid root login through SSH.
    PermitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    PasswordAuthentication = false;
  };
}
