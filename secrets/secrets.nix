let
  # rig SSH host key — run `cat /etc/ssh/ssh_host_ed25519_key.pub` on the rig
  # rig = "ssh-ed25519 AAAA_REPLACE_WITH_RIG_HOST_KEY";
	rig = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMIzAmne+srsRkLcpez9C0NWRexRW95ZCXRwte3KWZ73 root@nixos";
in
{
  "cloudflared-rig-ssh-token.age".publicKeys = [ rig ];
}
