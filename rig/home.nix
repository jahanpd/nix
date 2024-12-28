{ pkgs, config, lib, home-manager, ... }: {
  imports = [
    ../basehome.nix
  ];
  home.packages = [
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
			};
}
