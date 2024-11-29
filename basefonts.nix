{ pkgs, config, lib, ... }: {
			fonts.packages = with pkgs; [
					(nerdfonts.override { fonts = [ 
					"FiraCode" 
					"DroidSansMono"
					"Mononoki"
					]; })
			];
}
