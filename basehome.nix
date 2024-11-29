{ pkgs, config, lib, home-manager, ... }: {
	home.packages = [ 
		pkgs.bat 
	];
	programs.zsh = {
			enable = true;
			enableCompletion = true;
			syntaxHighlighting.enable = true;

			shellAliases = {
					nupdate = "darwin-rebuild switch --flake ~/nix#m1_air";
			};
			history = {
				size = 10000;
			};
			oh-my-zsh = {
				enable = true;
				plugins = [ "git" "thefuck" "fasd" "tmux" "vi-mode" "fzf"];
				theme = "sonicradish";
			};
			initExtra = ''
# my functions/aliases
source ~/Sync/zsh_custom
'';
		};

	programs.home-manager.enable = true;

	# The state version is required and should stay at the version you
	# originally installed.
	home.stateVersion = "24.11";
}
