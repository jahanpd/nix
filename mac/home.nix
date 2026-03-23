{ pkgs, config, lib, home-manager, osConfig, ... }: {
  imports = [
    ../basehome.nix
  ];

  programs.zsh.initContent = ''
    export CLAUDE_CODE_OAUTH_TOKEN=$(cat ${osConfig.age.secrets.claude-token.path})
  '';

  programs.zsh.shellAliases = {
					nupdate = "sudo darwin-rebuild switch --flake ~/nix#m1_air";
			};
}
