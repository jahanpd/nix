{ pkgs, config, lib, home-manager, ... }: {
  imports = [
    ../basehome.nix
  ];
  home.packages = [
		pkgs.gh
		pkgs.cloudflared
		pkgs.bun
		pkgs.kitty
		# lsps
		pkgs.basedpyright
  ];
  programs.zsh.shellAliases = {
					nupdate = "sudo nixos-rebuild switch --flake ~/nix#pi4";
			};
  # In your home-manager configuration (e.g. home.nix)

  wayland.windowManager.sway = {
			enable = true;
			wrapperFeatures.gtk = true;

			config = {
				modifier = "Mod4";
				terminal = "kitty";
				menu = "wmenu-run";

				left = "h";
				down = "j";
				up = "k";
				right = "l";

				bars = [{
					position = "top";
					statusCommand = "while date +'%Y-%m-%d %X'; do sleep 1; done";
					colors = {
						statusline = "#ffffff";
						background = "#323232";
						inactiveWorkspace = {
							border = "#32323200";
							background = "#32323200";
							text = "#5c5c5c";
						};
					};
				}];

				input = {
					# Example: uncomment and adjust as needed
					# "type:touchpad" = {
					#   dwt = "enabled";
					#   tap = "enabled";
					#   natural_scroll = "enabled";
					# };
				};

				keybindings = let
					mod = "Mod4";
				in {
					"${mod}+Return" = "exec kitty";
					"${mod}+Shift+q" = "kill";
					"${mod}+d" = "exec wmenu-run";
					"${mod}+Shift+c" = "reload";
					"${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

					# Focus
					"${mod}+h" = "focus left";
					"${mod}+j" = "focus down";
					"${mod}+k" = "focus up";
					"${mod}+l" = "focus right";
					"${mod}+Left" = "focus left";
					"${mod}+Down" = "focus down";
					"${mod}+Up" = "focus up";
					"${mod}+Right" = "focus right";

					# Move
					"${mod}+Shift+h" = "move left";
					"${mod}+Shift+j" = "move down";
					"${mod}+Shift+k" = "move up";
					"${mod}+Shift+l" = "move right";
					"${mod}+Shift+Left" = "move left";
					"${mod}+Shift+Down" = "move down";
					"${mod}+Shift+Up" = "move up";
					"${mod}+Shift+Right" = "move right";

					# Workspaces
					"${mod}+1" = "workspace number 1";
					"${mod}+2" = "workspace number 2";
					"${mod}+3" = "workspace number 3";
					"${mod}+4" = "workspace number 4";
					"${mod}+5" = "workspace number 5";
					"${mod}+6" = "workspace number 6";
					"${mod}+7" = "workspace number 7";
					"${mod}+8" = "workspace number 8";
					"${mod}+9" = "workspace number 9";
					"${mod}+0" = "workspace number 10";
					"${mod}+Shift+1" = "move container to workspace number 1";
					"${mod}+Shift+2" = "move container to workspace number 2";
					"${mod}+Shift+3" = "move container to workspace number 3";
					"${mod}+Shift+4" = "move container to workspace number 4";
					"${mod}+Shift+5" = "move container to workspace number 5";
					"${mod}+Shift+6" = "move container to workspace number 6";
					"${mod}+Shift+7" = "move container to workspace number 7";
					"${mod}+Shift+8" = "move container to workspace number 8";
					"${mod}+Shift+9" = "move container to workspace number 9";
					"${mod}+Shift+0" = "move container to workspace number 10";

					# Layout
					"${mod}+b" = "splith";
					"${mod}+v" = "splitv";
					"${mod}+s" = "layout stacking";
					"${mod}+w" = "layout tabbed";
					"${mod}+e" = "layout toggle split";
					"${mod}+f" = "fullscreen";
					"${mod}+Shift+space" = "floating toggle";
					"${mod}+space" = "focus mode_toggle";
					"${mod}+a" = "focus parent";

					# Scratchpad
					"${mod}+Shift+minus" = "move scratchpad";
					"${mod}+minus" = "scratchpad show";

					# Resize mode
					"${mod}+r" = "mode resize";

					# Media / brightness
					"--locked XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
					"--locked XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
					"--locked XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
					"--locked XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
					"--locked XF86AudioPlay" = "exec playerctl play-pause";
					"--locked XF86AudioPause" = "exec playerctl play-pause";
					"--locked XF86AudioPrev" = "exec playerctl previous";
					"--locked XF86AudioNext" = "exec playerctl next";
					"--locked XF86AudioStop" = "exec playerctl stop";
					"--locked XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
					"--locked XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
					"Print" = "exec grim";
				};

				modes = {
					resize = {
						"h" = "resize shrink width 10px";
						"j" = "resize grow height 10px";
						"k" = "resize shrink height 10px";
						"l" = "resize grow width 10px";
						"Left" = "resize shrink width 10px";
						"Down" = "resize grow height 10px";
						"Up" = "resize shrink height 10px";
						"Right" = "resize grow width 10px";
						"Return" = "mode default";
						"Escape" = "mode default";
					};
				};

				floating.modifier = "Mod4";
			};
		};
}
