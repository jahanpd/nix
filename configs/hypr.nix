{ pkgs, config, lib, home-manager, ... }: {
  home.file."~/.config/hypr/hyprland.conf".text = ''
# You have to change this based on your monitor
monitor=DP-2,5120x1440@60,0x0,1

# nvidia setup
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
cursor {
    no_hardware_cursors = true
}

# Status bar :)
# exec-once=eww open bar
exec-once=waybar

#Notification
exec-once=dunst

# Wallpaper
exec-once=swaybg -o \* -i ~/.config/hypr/wallpapers/night.jpg -m fill

# For screen sharing
exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# Bluetooth
exec-once=blueman-applet # Make sure you have installed blueman

# Screen Sharing
# exec-once=systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
# exec-once=~/.config/hypr/scripts/screensharing.sh

input {
    kb_layout = us
    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 1.0 # for mouse cursor
    force_no_accel = 1
}

# See https://wiki.hyprland.org/Configuring/Variables/
general {
    layout=dwindle

    gaps_in=5
    gaps_out=20
    border_size=0
    col.active_border=0xff5e81ac
    col.inactive_border=0x66333333

}

decoration {
    rounding=0
		active_opacity=1
		inactive_opacity=0.75
    blur {
        enabled=1
        size=6
        passes=2
        new_optimizations = true

        # Your blur "amount" is size * passes, but high size (over around 5-ish)
        # will produce artifacts.
        # if you want heavy blur, you need to up the passes.
        # the more passes, the more you can up the size without noticing artifacts.
    }
}

blurls=waybar
blurls=lockscreen

animations {
    enabled=1
    # bezier=overshot,0.05,0.9,0.1,1.1
    bezier=overshot,0.13,0.99,0.29,1.1
    animation=windows,1,4,overshot,popin
    animation=fade,1,10,default
    animation=workspaces,1,6,overshot,slide
    animation=border,1,10,default
}

dwindle {
    pseudotile=1 # enable pseudotiling on dwindle
    # force_split=2
    force_split=0
}

master {
    new_on_top=true
}

misc {
    disable_hyprland_logo=true
    disable_splash_rendering=true
    mouse_move_enables_dpms=true
    vfr = false
}
# sources
source = ~/.config/hypr/keybindings.conf
# Float Necessary Windows
windowrule=float,Rofi
windowrule=float,pavucontrol
windowrulev2 = float,class:^()$,title:^(Picture in picture)$
windowrulev2 = float,class:^(brave)$,title:^(Save File)$
windowrulev2 = float,class:^(brave)$,title:^(Open File)$
windowrulev2 = float,class:^(LibreWolf)$,title:^(Picture-in-Picture)$
windowrulev2 = float,class:^(blueman-manager)$
windowrulev2 = float,class:^(org.twosheds.iwgtk)$
windowrulev2 = float,class:^(blueberry.py)$
windowrulev2 = float,class:^(xdg-desktop-portal-gtk)$
windowrulev2 = float,class:^(geeqie)$

# Fix sharring wuth discord https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
windowrulev2 = opacity 0.0 override, class:^(xwaylandvideobridge)$
windowrulev2 = noanim, class:^(xwaylandvideobridge)$
windowrulev2 = noinitialfocus, class:^(xwaylandvideobridge)$
windowrulev2 = maxsize 1 1, class:^(xwaylandvideobridge)$
windowrulev2 = noblur, class:^(xwaylandvideobridge)$

# Increase the opacity
windowrule=opacity 0.92,Thunar
windowrule=opacity 0.96,discord
windowrule=opacity 0.9,VSCodium
windowrule=opacity 0.88,obsidian
# Window Rules > Visual Studio Code
windowrule=opacity .95 ,^(Code)$


#^.*nvim.*$
windowrule=tile,librewolf
windowrule=tile,spotify
windowrule=opacity 1,neovim
bindm=SUPER,mouse:272,movewindow
bindm=SUPER,mouse:273,resizewindow
'';
  home.file."~/.config/hypr/keybindings.conf".text = ''
# launch terminal
bind=SUPER SHIFT,RETURN,exec,alacritty

# launch app selector
bind=SUPER,p,exec,rofi -show drun

# kill window
bind=SUPER SHIFT,c,killactive

# exit session
bind = SUPER,M,exit

# quit hyprland
bind=SUPERSHIFT,q,exit


bind=SUPER,F,fullscreen,1
bind=SUPERSHIFT,F,fullscreen,0
bind=SUPER,E,exec,pcmanfm

## Screen shot
bind=SUPERSHIFT,S,exec,grim -g "$(slurp)"
## Emoji selector
bind=SUPERSHIFT,E,exec,rofi -modi emoji -show emoji

bind=SUPER,j,movefocus,d
bind=SUPER,k,movefocus,u

bind=SUPER,h,movefocus,l
bind=SUPER,l,movefocus,r

bind=SUPER SHIFT,y,resizeactive,-40 0
bind=SUPER SHIFT,o,resizeactive,40 0

bind=SUPER SHIFT,i,resizeactive,0 -40
bind=SUPER SHIFT,u,resizeactive,0 40

bind=SUPERSHIFT,h,movewindow,l
bind=SUPERSHIFT,l,movewindow,r
bind=SUPERSHIFT,k,movewindow,u
bind=SUPERSHIFT,j,movewindow,d

bind=SUPER,1,workspace,1
bind=SUPER,2,workspace,2
bind=SUPER,3,workspace,3
bind=SUPER,4,workspace,4
bind=SUPER,5,workspace,5
bind=SUPER,6,workspace,6
bind=SUPER,7,workspace,7
bind=SUPER,8,workspace,8
bind=SUPER,9,workspace,9
bind=SUPER,0,workspace,10

bind=SUPERSHIFT,1,movetoworkspacesilent,1
bind=SUPERSHIFT,2,movetoworkspacesilent,2
bind=SUPERSHIFT,3,movetoworkspacesilent,3
bind=SUPERSHIFT,4,movetoworkspacesilent,4
bind=SUPERSHIFT,5,movetoworkspacesilent,5
bind=SUPERSHIFT,6,movetoworkspacesilent,6
bind=SUPERSHIFT,7,movetoworkspacesilent,7
bind=SUPERSHIFT,8,movetoworkspacesilent,8
bind=SUPERSHIFT,9,movetoworkspacesilent,9
bind=SUPERSHIFT,0,movetoworkspacesilent,10
'';

}


