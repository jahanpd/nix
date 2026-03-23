{ pkgs, config, lib, home-manager, ... }: {
  imports = [
    ../basehome.nix
  ];

  home.sessionVariables = {
    CLAUDE_CODE_OAUTH_TOKEN = "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";
  };

  programs.zsh.shellAliases = {
					nupdate = "sudo darwin-rebuild switch --flake ~/nix#m1_air";
			};
}
