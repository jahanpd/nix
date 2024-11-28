{ pkgs, config, lib, ... }: {
		imports = [ <home-manager/nix-darwin> ];
		users.users.eve = {
			name = "jahan";
			home = "/Users/jahan";
		};
		home-manager.users.eve = { pkgs, ... }: {
			home.packages = [ 
			  pkgs.bat 
				pkgs.fzf
		  ];
			programs.zsh = {
					enable = true;
					enableCompletion = true;
					autosuggestions.enable = true;
					syntaxHighlighting.enable = true;

					shellAliases = {
					};
					history = {
						size = 10000;
						path = "${config.xdg.dataHome}/zsh/history";
					};
					oh-my-zsh = {
						enable = true;
						plugins = [ "git" "thefuck" "fasd" "tmux" "vi-mode" "fzf"];
						theme = "robbyrussell";
					};

				};

			# The state version is required and should stay at the version you
			# originally installed.
			home.stateVersion = "24.05";
		};
}
