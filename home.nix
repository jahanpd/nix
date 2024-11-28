{ pkgs, config, lib, home-manager, ... }: {
		users.users.jahan = {
			name = "jahan";
			home = "/Users/jahan";
		};
		home-manager.users.jahan = { pkgs, ... }: {
			home.packages = [ 
			  pkgs.bat 
				pkgs.fzf
		  ];
			programs.zsh = {
					enable = true;
					enableCompletion = true;
					syntaxHighlighting.enable = true;

					shellAliases = {
					};
					history = {
						size = 10000;
					};
					oh-my-zsh = {
						enable = true;
						plugins = [ "git" "thefuck" "fasd" "tmux" "vi-mode" "fzf"];
						theme = "sonicradish";
					};

				};

			# The state version is required and should stay at the version you
			# originally installed.
			home.stateVersion = "24.11";
		};
}
