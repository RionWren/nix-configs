# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "uas" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -m 0755 -p /key
    sleep 4
    mount -n -t vfat -o ro `findfs UUID=C811-2B6A` /key
  '';

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ddef3772-2d25-462a-bf4e-5fe4612b1299";
    fsType = "xfs";
  };

  boot.initrd.luks.devices."luks-a357230a-c779-464f-ae20-74a9640d441e" = {
    device = "/dev/disk/by-uuid/a357230a-c779-464f-ae20-74a9640d441e";
    keyFile = "/key/desktop.key";
    preLVM = false;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7ADC-AAF5";
    fsType = "vfat";
  };

#  fileSystems."/Data" = {
#    device = "/dev/disk/by-uuid/701d0b93-031e-431d-aef4-cfd792f520f0";
#    fsType = "xfs";
#  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/a37605d1-196b-4dcc-bd98-4ec789d87cf1";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp6s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
