{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../basepkgs.nix
      ../basefonts.nix
    ];

  boot.loader.systemd-boot.enable = true;
	# boot.blacklistedKernelModules = [ "nouveau" "i2c_nvidia_gpu" ];
	boot.supportedFilesystems = [ "ntfs" "xfs" ];


  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.networkmanager.ensureProfiles.profiles = {
    pi-fi = {
    connection = {
      id = "pi-fi";
      permissions = "";
      type = "wifi";
			autoconnect = true;
    };
    ipv4 = {
      method = "auto";
    };
    ipv6 = {
      method = "auto";
    };
    wifi = {
      mac-address-blacklist = "";
      mode = "infrastructure";
      ssid = "peter_duttons_onlyfans";
    };
    wifi-security = {
      key-mgmt = "wpa-psk";
      psk = "${builtins.readFile /home/jahan/wifipsk.txt}";
    };
   };
  };

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  services = {
    syncthing = {
        enable = true;
        group = "wheel";
        user = "jahan";
        dataDir = "/home/jahan/Sync";    # Default folder for new synced folders
        configDir = "/home/jahan/.local/state/syncthing/";   # Folder for Syncthing's settings and keys
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jahan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
  };
	# this is a user for SSHing with a very high entropy password
  users.users.pen15 = {
    isNormalUser = true;
    shell = pkgs.zsh;
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kitty
		docker-compose
		cudaPackages.cudatoolkit
		cudaPackages.cudnn
		cachix
		gcc
		unifi
  ];

  environment.variables.EDITOR = "nvim";

  programs.zsh.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
			enable = true;
			ports = [ 121 ];
			settings = {
					PasswordAuthentication = true;
					AllowUsers = [ "pen15" ];
					PermitRootLogin = "no";
			};
	};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 8096 80 443 8000 7844 ];
  # networking.firewall.allowedUDPPorts = [ 8096 80 443 8000 7844 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


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

