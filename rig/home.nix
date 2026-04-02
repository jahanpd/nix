{ pkgs, config, lib, home-manager, osConfig, ... }: {
  imports = [
    ../basehome.nix
  ];
  programs.zsh.initContent = ''
    export CLAUDE_CODE_OAUTH_TOKEN=$(cat ${osConfig.age.secrets.claude-token.path})
  '';

  home.packages = [
	  pkgs.wl-clipboard
	  pkgs.emacs
    pkgs.waybar
    pkgs.rofi
		pkgs.alacritty
		pkgs.awww
		pkgs.gh
		pkgs.swayidle
		pkgs.ffmpeg
		pkgs.cloudflared
		# lsps
		pkgs.basedpyright
		pkgs.bun
		pkgs.firefox
  ];
  programs.zsh.shellAliases = {
					nupdate = "sudo nixos-rebuild switch --flake ~/nix#nixos";
					rollthedice = ''awww img "$(find /home/jahan/.config/hypr/wallpapers/ -type f | shuf -n 1)"'';
					addssd = "sudo mount 4a3f54f6-e7e6-4b53-94b0-8600e914a8ed -U /mnt/sketchy";
					magictrack = "bluetoothctl connect 3C:50:02:BF:9E:00";
			};
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    PATH = "${config.home.homeDirectory}/.npm-global/bin:$PATH";
  };
}
