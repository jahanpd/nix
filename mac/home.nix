{ pkgs, config, lib, home-manager, ... }: {
  imports = [
    ../basehome.nix
  ];

  programs.zsh.shellAliases = {
					nupdate = "darwin-rebuild switch --flake ~/nix#m1_air";
			};
}
