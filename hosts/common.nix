{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://hyprland.cachix.org"
    "https://nixpkgs-wayland.cachix.org"
    "https://cache.garnix.io"
  ];

  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  ];

  nix.package = pkgs.lix;

  programs.dconf.enable = true;

  programs.fish.enable = true;

  programs.flashrom.enable = true;

  programs.hyprlock.enable = true;

  environment.systemPackages = with pkgs; [
    bluez-alsa
    bluez
    nemo
    dbus
    fzf
    grimblast
    libsForQt5.qt5ct
    lxqt.lxqt-policykit
    mesa
    openrazer-daemon
    pavucontrol
    playerctl
    pulseaudio
    swaybg
    swayidle
    swayosd
    temurin-bin
    temurin-jre-bin-8
    udiskie
    wget
    wl-clipboard
    xdg-utils
    wvkbd
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
    config.nur.repos.ilya-fedin.exo2
  ];

  fonts.fontconfig.defaultFonts = {
    serif = ["Noto Serif" "Source Han Serif"];
    sansSerif = ["Noto Sans" "Source Han Sans"];
  };

  hardware.bluetooth.enable = true;
  hardware.openrazer.enable = true;

  services.acpid.enable = true;
  services.blueman.enable = true;
  services.dbus.enable = true;
  services.lvm.enable = true;
  services.printing.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing.drivers = [ pkgs.gutenprint ];

  console.useXkbConfig = true;

  services.greetd = {
    enable = true;
    restart = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = "true";
    TTYHangup = "true";
    TTYVTDisallocate = true;
  };

  networking.networkmanager.enable = true;

  boot.supportedFilesystems = ["exfat" "ntfs" "xfs"];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;

  systemd = {
    user.services.polkit-lxqt = {
      description = "polkit-lxqt";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  users.defaultUserShell = pkgs.fish;

  system.stateVersion = "24.05";
}
