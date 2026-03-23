{ pkgs, config, lib, home-manager, ... }: {
  imports = [
    ../basehome.nix
  ];

  programs.zsh.initExtra = ''
    export CLAUDE_CODE_OAUTH_TOKEN=$(cat /run/agenix/claude-token)
  '';

  programs.zsh.shellAliases = {
					nupdate = "sudo darwin-rebuild switch --flake ~/nix#m1_air";
			};
}
