{ pkgs, config, lib, self, ... }: {
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [   
						pkgs.neovim
						pkgs.git
						pkgs.curl
						pkgs.fzf
						pkgs.ripgrep
						pkgs.syncthing
						pkgs.nodejs
						pkgs.texliveMedium
						pkgs.cmake # for building
						pkgs.typescript
						pkgs.typescript-language-server
						pkgs.lua-language-server
						pkgs.mkcert
						pkgs.nss
						pkgs.claude-code
						pkgs.pandoc
        ];
}
