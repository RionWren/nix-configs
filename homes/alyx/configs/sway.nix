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
    { command = "swaybg -m fit -i ~/.config/nixos/images/halftone-purple.png"; }
    { command = "swaync"; }
  ];
  workspaceLayout = "default";
  keybindings = lib.mkOptionDefault {
    "Mod4+s" = "exec foot --title launch --app-id fzf-launcher bash -c 'compgen -c | sort -u | fzf | xargs swaymsg exec --'";
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
  };
  floating.criteria = [
    { app_id = "^fzf-launcher$";}
  ];
  window = {
    titlebar = false;
  };
}
