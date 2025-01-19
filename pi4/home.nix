{ pkgs, config, lib, home-manager, ... }: {
  imports = [
    ../basehome.nix
  ];
  home.packages = [
		pkgs.gh
		pkgs.cloudflared
		# lsps
		pkgs.basedpyright
  ];
  programs.zsh.shellAliases = {
					nupdate = "sudo nixos-rebuild switch --flake ~/nix#pi4";
			};
}
