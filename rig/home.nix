{ pkgs, config, lib, home-manager, ... }: {
  imports = [
    ../basehome.nix
  ];
  home.packages = [
    pkgs.waybar
    pkgs.rofi
		pkgs.alacritty
		pkgs.swww
  ];
}
