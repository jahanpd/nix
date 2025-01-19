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
  ];
  programs.zsh.shellAliases = {
					nupdate = "sudo nixos-rebuild switch --flake ~/nix#nixos";
					rollthedice = ''swww img "$(find /home/jahan/.config/hypr/wallpapers/ -type f | shuf -n 1)"'';
			};
}
