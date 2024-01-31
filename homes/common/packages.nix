{pkgs, ...}: {
  home.packages = with pkgs; [
    beeper
    brightnessctl
    easyeffects
    fastfetch
    firefox-devedition
    gparted
    hyfetch
    krita
    libsForQt5.ark
    mumble
    networkmanagerapplet
    obs-studio
    pamixer
    prismlauncher
    prusa-slicer
    rnote
    scrcpy
    signal-desktop
    steam
    stellarium
    tetrio-desktop
    timidity
    transmission-qt
    vesktop
    vlc
    vscodium
    wdisplays
    wl-clipboard
    wofi
  ];
}
