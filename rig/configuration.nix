{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../basepkgs.nix
      ../basefonts.nix
			./docker.nix
			./nginx.nix
			../cachix.nix
    ];

  boot.loader.systemd-boot.enable = true;
	# boot.blacklistedKernelModules = [ "nouveau" "i2c_nvidia_gpu" ];
	boot.supportedFilesystems = [ "ntfs" "xfs" ];
	boot.kernelModules = ["hid_apple"];


  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # bluetooth
  hardware.bluetooth.enable = true;
	hardware.bluetooth.settings = {
    General = {
      FastConnectable = true;
			Experimental = true;
    };
  };
	services.upower.enable = true;

  # nvidia setup
  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
	hardware.nvidia-container-toolkit.enable = true;
  # potentially critical for running dynamic binaries eg bundled cuda
	programs.nix-ld.enable = true;

	services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
	networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

services.resolved = {
  enable = true;
  dnssec = "true";
  domains = [ "~." ];
  fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  dnsovertls = "true";
};

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		jack.enable = true;
  };

	xdg.portal.extraPortals = with pkgs; [
		xdg-desktop-portal-hyprland
		xdg-desktop-portal-gtk
	];

  services.getty.autologinOnce = true;
	services.getty.autologinUser = "jahan";

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #TYPE DATABASE    USER    ADDRESS        METHOD
      local all         all                    trust
			host  all         all     127.0.0.1/32   trust
    '';
  };

  services.tailscale = {
					enable = true;
			};

  services.redis.servers = {
		"cache" = {
				enable = true;
				port = 6380;
				user = "redis-cache";
				settings = {
						dir = "/var/lib/redis-cache";
						maxmemory        = "256mb";
						maxmemory-policy = "volatile-lru";
				};
		};
		"session" = {
      enable     = true;
      port       = 6381;
      user       = "redis-session";
			settings = {
				  	dir    = "/var/lib/redis-session";
						maxmemory        = "256mb";
						maxmemory-policy = "volatile-lru";
				};
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
	nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
	  obs-studio
		shotcut
    kitty
		docker-compose
		cudaPackages.cudatoolkit
		cudaPackages.cudnn
		cachix
		gcc
		unifi
		vscode
		R
		uv
		bluez
		openssl
	  transmission_4-qt6
		ollama
  ];

  services = {
    syncthing = {
        enable = true;
        group = "wheel";
        user = "jahan";
        dataDir = "/home/jahan/Sync";    # Default folder for new synced folders
        configDir = "/home/jahan/.local/state/syncthing/";   # Folder for Syncthing's settings and keys
    };
		transmission = {
			enable = true;
			package = pkgs.transmission_4;
		};
  };

  age.secrets.cloudflared-rig-ssh-token = {
    file = ../secrets/cloudflared-rig-ssh-token.age;
    owner = "jahan";
  };

  age.secrets.claude-token = {
    file = ../secrets/claude-token.age;
    owner = "jahan";
  };

  systemd.services.cloudflared-tunnel = {
    description = "Cloudflared Tunnel Service for SSH";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = pkgs.writeShellScript "cloudflared-tunnel" ''
        exec ${pkgs.cloudflared}/bin/cloudflared tunnel run --token $(cat ${config.age.secrets.cloudflared-rig-ssh-token.path})
      '';
      Restart = "on-failure";
      RestartSec = 5;
      User = "jahan";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jahan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
		openssh.authorizedKeys.keys = [
		  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILG7+2Q8+DBxfiCYPdJY+q+gA/wULeshWhMXMD+WVQP2"
    ];
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
			enable = true;
			ports = [ 22 ];
			settings = {
					PasswordAuthentication = false;
					PermitRootLogin = "no";
			};
	};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 8096 80 443 8000 7844 ];
  # networking.firewall.allowedUDPPorts = [ 8096 80 443 8000 7844 3478 19302 ];
  # networking.firewall.allowedUDPPortRanges = [{ from = 49152; to = 65535;}];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

