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
  
  hardware.opengl.extraPackages = with pkgs; [
    vulkan-validation-layers
    vaapiVdpau
    libvdpau-va-gl
  ];

  services.xserver = {
    xkb.variant = lib.mkForce "colemak";
    xkb.layout = lib.mkForce "gb";
  };

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
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
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;

  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {


      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      PLATFORM_PROFILE_ON_BAT = "low-power";
      PLATFORM_PROFILE_ON_AC = "performance";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      RUNTIME_PM_DRIVER_DENYLIST = "mei_me";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 40;
    };
  };

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
  boot.initrd.luks.devices."luks-6240becf-04f7-4086-989c-95f51b0a5120".device = "/dev/disk/by-uuid/6240becf-04f7-4086-989c-95f51b0a5120";
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
