{lib, ...}:{
  modifier = "Mod4";
  terminal = "foot";
  gaps = {
    inner = 5;
    outer = 7;
  };
  input = {
    "type:touchpad" = {
      accel_profile = "flat";
      dwt = "disabled";
      scroll_factor = "0.3";
    };
    "type:mouse" = {
      accel_profile = "flat";
    };
    "1:1:AT_Translated_Set_2_keyboard" = {
      xkb_layout = "us";
      xkb_variant = "colemak";
    };
  };
  bars = [];
  defaultWorkspace = "workspace number 1";
  startup = [
    { command = "udiskie"; }
    { command = "swaybg -m fill -i ~/.config/nixos/images/halftone-purple.png"; }
    { command = "swaync"; }
  ];

  seat = {
    "*" = {
      xcursor_theme = "catppuccin-mocha-mauve-cursors 48";
    };
  };

  output = {
    DP-1 = {
      mode = "2560x1080";
      pos = "1920 0";
    };
    DP-2 = {
      mode = "1920x1080@239.760Hz";
      pos = " 0 0";
    };
  };

  workspaceLayout = "default";
  keybindings = lib.mkOptionDefault {
    "Mod4+Shift+f" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
    "Mod4+Shift+n" = "move down";
    "Mod4+Shift+e" = "move up";
    "Mod4+Shift+i" = "move right";
    "Mod4+s" = "exec foot --title launch --app-id fzf-launcher bash -c 'compgen -c | sort -u | fzf | xargs swaymsg exec --'";
    "Mod4+f" = "layout toggle split";
    "Mod4+t" = "fullscreen toggle";
    "Mod4+n" = "focus down";
    "Mod4+e" = "focus up";
    "Mod4+i" = "focus right";
    "Mod4+p" = "mode resize";
    "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0";
    "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
    "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    "XF86AudioPlay" = "exec playerctl play-pause";
    "XF86AudioNext" = "exec playerctl next";
    "XF86AudioPrev" = "exec playerctl previous";
    "XF86AudioStop" = "exec playerctl stop";
    "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
    "XF86MonBrightnessUp" = "exec brightnessctl s +10%";
    "XF86AudioMedia" = "exec vlc";
    "XF86Launch1" = "exec nmcli device wifi rescan";
    "Shift_L+Control_L+B" = "exec playerctl position 10-";
    "Shift_L+Control_L+F" = "exec playerctl position 10+";
    "Mod4+Shift+s" = "exec grimblast copy area";
  };
  floating.criteria = [
    { app_id = "^fzf-launcher$";}
  ];
  window = {
    titlebar = false;
  };
}
