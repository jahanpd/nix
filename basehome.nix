{ pkgs, config, lib, home-manager, ... }: {
	home.packages = [ 
		pkgs.bat 
	];
	programs.zsh = {
			enable = true;
			enableCompletion = true;
			syntaxHighlighting.enable = true;
			history = {
				size = 10000;
			};
			oh-my-zsh = {
				enable = true;
				plugins = [ "git" "fasd" "tmux" "vi-mode" "fzf"];
				theme = "sonicradish";
			};
			initContent = ''
# my functions/aliases
source ~/Sync/zsh_custom
'';
		};

  programs.tmux = {
			enable = true;
			clock24 = true;  # Example option to use 24-hour clock format
			terminal = "tmux-256color";       # Set terminal type
			historyLimit = 100000;            # Set history limit
			plugins = with pkgs.tmuxPlugins; [
			  better-mouse-mode
				{
					plugin = catppuccin;
					extraConfig = ''
						set -g @catppuccin_flavour 'mocha'
						set -g @catppuccin_window_default_text "#W"
						set -g @catppuccin_window_text "#W"
						set -g @catppuccin_window_current_text "#W"
					'';
				}
			];
			extraConfig = ''
				# Additional tmux configurations can be added here
				set -g pane-base-index 1
				set -g base-index 1
				set -g mouse on
				set-option -g allow-rename off
			'';
  };

	programs.home-manager.enable = true;

	# The state version is required and should stay at the version you
	# originally installed.
	home.stateVersion = "24.11";
}
