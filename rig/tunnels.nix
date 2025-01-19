{ config, pkgs, ... }:
# https://mdleom.com/blog/2021/06/15/cloudflare-argo-nixos/
{
  services.cloudflared = {
    enable = true;
		user = "jahan";
    tunnels = {
      "whisper" = {
        default = "http_status:404";
        ingress = {
          "whisper.medguard.app" = {
							service = "http://localhost:8000";
					};
        };
        credentialsFile = "${config.users.users.jahan.home}/.cloudflared/c392d440-f90b-4ab1-8081-a24659f6519f.json";
      };
    };
  };
}
