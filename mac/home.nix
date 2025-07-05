{ pkgs, config, lib, home-manager, ... }: {
  imports = [
    ../basehome.nix
  ];

  programs.zsh.shellAliases = {
					nupdate = "sudo darwin-rebuild switch --flake ~/nix#m1_air";
			};
}
