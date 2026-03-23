let
  # rig SSH host key — run `cat /etc/ssh/ssh_host_ed25519_key.pub` on the rig
  rig = "ssh-ed25519 AAAA_REPLACE_WITH_RIG_HOST_KEY";
	mac = "ssh-ed25519 <YOUR_MAC_HOST_KEY>";
in
{
  "cloudflared-rig-token.age".publicKeys = [ rig ];
	"claude-token.age".publicKeys = [ mac ];
}
