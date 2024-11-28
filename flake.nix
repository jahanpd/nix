{
  description = "Fo shizzle nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
		home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
  {
		# config for 
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [
						./rig/configuration.nix
						home-manager.nixosModules.home-manager
						{
								home-manager.useGlobalPkgs = true;
								home-manager.useUserPackages = true;
								home-manager.users.jahan = import ./rig/home.nix;
						}
        ];

		};

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."m1_air" = nix-darwin.lib.darwinSystem {
		  specialArgs = { inherit inputs self; };
      modules = [ 
					./mac/configuration.nix 
					home-manager.darwinModules.home-manager
					{
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jahan = import ./mac/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
			];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."m1_air".pkgs;
  };
}
