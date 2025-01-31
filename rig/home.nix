{ pkgs, config, lib, home-manager, ... }: {
  imports = [
    ../basehome.nix
  ];
  home.packages = [
	  pkgs.emacs
    pkgs.waybar
    pkgs.rofi
		pkgs.alacritty
		pkgs.swww
		pkgs.bitwarden-desktop
		pkgs.gh
		pkgs.swayidle
		pkgs.ffmpeg
		pkgs.cloudflared
		# lsps
		pkgs.basedpyright
  ];
  programs.zsh.shellAliases = {
					nupdate = "sudo nixos-rebuild switch --flake ~/nix#nixos";
					rollthedice = ''swww img "$(find /home/jahan/.config/hypr/wallpapers/ -type f | shuf -n 1)"'';
					addssd = "sudo mount 4a3f54f6-e7e6-4b53-94b0-8600e914a8ed -U /mnt/sketchy";
			};
}
