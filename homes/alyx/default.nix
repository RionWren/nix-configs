{
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:{
  imports = [
    ./packages.nix # home.packages and similar stuff
    ./programs.nix # programs.<programName>.enable
    ./configs/git.nix
    ./configs/nvim-flake.nix
    ./ags
  ];

  home = {
    username = "alyx";
    homeDirectory = "/home/alyx";
     file.".config/hypr/hyprlock.conf".source= ./configs/hyprlock.conf;
     file.".config/lockonsleep/config.sh".source = ./configs/lock.sh;
     file.".config/foot/foot.ini".source = ./configs/foot.ini;
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 48;
    };
  };

  services.arrpc.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        size = "standard";
        variant = "mocha";
      };
    };

    cursorTheme = {
      name = "catppuccin-mocha-mauve-cursors";
      package = pkgs.catppuccin-cursors.mochaMauve;
      size = 48;
    };
  };
  
  qt.enable = true;
  qt.platformTheme.name = "gtk";

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  wayland.windowManager.sway = {
    package = pkgs.swayfx;
    enable = true;
    checkConfig = false;
    config = import ./configs/sway.nix;
    extraConfig = import ./configs/swayfx;
    extraOptions = [ "--unsupported-gpu" ];
  };

  services.udiskie.enable = true;

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  # Nicely reload system(d) units when changing configs
  systemd.user.startServices = lib.mkDefault "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
