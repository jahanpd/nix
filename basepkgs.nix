{ pkgs, config, lib, self, ... }: {
      nixpkgs.config.allowUnfree = true;

      # pyqt5 5.15.10 doesn't build with the sip in current nixpkgs, which
      # breaks asymptote (its xasy GUI needs pyqt5) and therefore
      # texliveMedium. Stub pyqt5 out of asymptote's python env: xasy won't
      # launch, but asymptote itself and the rest of texlive work fine.
      nixpkgs.overlays = [
        (final: prev: {
          asymptote = prev.asymptote.override {
            python3 = prev.python3.override {
              packageOverrides = pyfinal: pyprev: {
                pyqt5 = pyfinal.buildPythonPackage {
                  pname = "pyqt5-stub";
                  version = "0";
                  format = "other";
                  dontUnpack = true;
                  installPhase = "mkdir -p $out";
                };
              };
            };
          };
        })
      ];

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
						pkgs.pandoc
        ];
}
