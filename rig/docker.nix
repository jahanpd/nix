{ config, lib, pkgs, ... }:
{
		virtualisation.docker.enable = true;
		users.users.jahan.extraGroups = [ "docker" ];
		virtualisation.docker.daemon.settings = {
			data-root = "/home/jahan/ssd3/docker";
		};
}
