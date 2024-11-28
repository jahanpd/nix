{ pkgs, config, lib, self, ... }: {
		  users.users.jahan = {
			  name = "jahan";
			  home = "/Users/jahan";
		  };

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [   pkgs.neovim
						pkgs.zoom-us
						pkgs.tmux
						pkgs.brave
						pkgs.fzf
						pkgs.nodejs_23
						pkgs.syncthing
						pkgs.emacs
						pkgs.texliveMedium
						pkgs.cmake # for building
						pkgs.ollama
						pkgs.thefuck
        ];
      homebrew = {
					enable=true;
					brews=[
						"libtool"
					];
					casks = [
					  "alacritty"
						"libreoffice"
						"jabref"
						"nanosaur"
					];
        onActivation.cleanup = "zap";
				onActivation.autoUpdate = true;
				onActivation.upgrade = true;
       };

			fonts.packages = with pkgs; [
					(nerdfonts.override { fonts = [ 
					"FiraCode" 
					"DroidSansMono"
					"Mononoki"
					]; })
			];
		  # copy apps installed by nix to app directory to show up in spotlight
		  system.activationScripts.applications.text = lib.mkForce ''
				echo "Setting up /Applications/Nix Apps" >&2
				appsSrc="${config.system.build.applications}/Applications/"
				baseDir="/Applications/Nix Apps"
				mkdir -p "$baseDir"
				${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$appsSrc" "$baseDir"
			'';

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
}
