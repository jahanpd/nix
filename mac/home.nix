{ pkgs, config, lib, home-manager, osConfig, ... }: {
  imports = [
    ../basehome.nix
  ];

  programs.zsh.initContent = ''
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
  '';

  programs.zsh.shellAliases = {
					nupdate = "sudo darwin-rebuild switch --flake ~/nix#m1_air";
			};

  # nix-homebrew sets HOMEBREW_NO_INSTALL_FROM_API, so non-official taps must be
  # explicitly trusted (Homebrew 6.x). Declare the trust here instead of running
  # `brew trust` by hand. Mirror this whenever a new third-party tap is added.
  home.file.".homebrew/trust.json" = {
    force = true;  # replace the file `brew trust` may have written
    text = builtins.toJSON {
      trustedformulae = [ "qmk/qmk/qmk" ];
      trustedtaps = [ "osx-cross/arm" "osx-cross/avr" "qmk/qmk" ];
    };
  };
}
