{
  description = "big boi pants aint flakey";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Homebrew taps pinned for nix-homebrew (mutableTaps = false)
    homebrew-core   = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask   = { url = "github:homebrew/homebrew-cask"; flake = false; };
    homebrew-bundle = { url = "github:homebrew/homebrew-bundle"; flake = false; };
    qmk-qmk         = { url = "github:qmk/homebrew-qmk"; flake = false; };
    osx-cross-arm   = { url = "github:osx-cross/homebrew-arm"; flake = false; };
    osx-cross-avr   = { url = "github:osx-cross/homebrew-avr"; flake = false; };

		home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, agenix, ... }:
  {
		# config for main rig
		nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [
						./rig/configuration.nix
						agenix.nixosModules.default
						home-manager.nixosModules.home-manager
						{
								home-manager.useGlobalPkgs = true;
								home-manager.useUserPackages = true;
								home-manager.users.jahan = import ./rig/home.nix;
						}
        ];

		};

		# config for pi4
		nixosConfigurations."pi4" = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				specialArgs = { inherit inputs; };
				modules = [
						./pi4/configuration.nix
						home-manager.nixosModules.home-manager
						{
								home-manager.useGlobalPkgs = true;
								home-manager.useUserPackages = true;
								home-manager.users.jahan = import ./pi4/home.nix;
						}
        ];

		};

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."m1_air" = nix-darwin.lib.darwinSystem {
		  specialArgs = { inherit inputs self; };
      modules = [
					./mac/configuration.nix
					agenix.darwinModules.default
					nix-homebrew.darwinModules.nix-homebrew
					{
            nix-homebrew = {
              enable = true;
              user = "jahan";
              enableRosetta = false;   # aarch64-only machine
              autoMigrate = true;       # adopt the existing /opt/homebrew install
              mutableTaps = false;      # taps come from the Nix store -> no trust prompts
              taps = {
                "homebrew/homebrew-core"   = inputs.homebrew-core;
                "homebrew/homebrew-cask"   = inputs.homebrew-cask;
                "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                "qmk/homebrew-qmk"         = inputs.qmk-qmk;
                "osx-cross/homebrew-arm"   = inputs.osx-cross-arm;
                "osx-cross/homebrew-avr"   = inputs.osx-cross-avr;
              };
            };
          }
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
