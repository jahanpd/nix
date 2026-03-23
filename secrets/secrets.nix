let
  # rig SSH host key — run `cat /etc/ssh/ssh_host_ed25519_key.pub` on the rig
	rig = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMIzAmne+srsRkLcpez9C0NWRexRW95ZCXRwte3KWZ73 root@nixos";
	mac = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILG7+2Q8+DBxfiCYPdJY+q+gA/wULeshWhMXMD+WVQP2";
in
{
  "cloudflared-rig-token.age".publicKeys = [ rig ];
	"claude-token.age".publicKeys = [ mac ];
}
