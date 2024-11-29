{ pkgs, config, lib, self, ... }: {
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [   pkgs.neovim
						pkgs.zoom-us
						pkgs.tmux
						pkgs.brave
						pkgs.fzf
						pkgs.syncthing
						pkgs.nodejs_23
						pkgs.emacs
						pkgs.texliveMedium
						pkgs.cmake # for building
						pkgs.ollama
						pkgs.thefuck
        ];
}
