{ pkgs, config, lib, self, ... }: {
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [   
						pkgs.neovim
						pkgs.git
						pkgs.curl
						pkgs.zoom-us
						pkgs.tmux
						pkgs.brave
						pkgs.fzf
						pkgs.ripgrep
						pkgs.syncthing
						pkgs.nodejs_23
						pkgs.texliveMedium
						pkgs.cmake # for building
						pkgs.thefuck
        ];
}
