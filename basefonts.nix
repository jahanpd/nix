{ pkgs, config, lib, ... }: {
fonts.packages = with pkgs; [
	noto-fonts
	nerd-fonts.fira-code
	nerd-fonts.droid-sans-mono
	nerd-fonts.mononoki
];
}
