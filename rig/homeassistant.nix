{ config, lib, pkgs, ... }:
{
  services.home-assistant = {
    enable = true;

    # HA Core can't install integration deps at runtime on NixOS, so every
    # integration you actually use must be listed here to have its Python
    # dependencies built into the environment.
    extraComponents = [
      "default_config"   # onboarding + mobile_app + stream + ffmpeg + zeroconf
      "esphome"          # garage-door ESP node (native API, auto-discovered)
      "reolink"          # the WiFi camera
      "met"              # weather
      "radio_browser"
      "bluetooth"        # hardware.bluetooth is enabled on the rig
    ];

    extraPackages = ps: with ps; [
      # psycopg2   # if you point the recorder at the local postgres
    ];

    config = {
      default_config = {};
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        temperature_unit = "C";
        time_zone = config.time.timeZone;   # Australia/Melbourne
      };
      # Let the UI write automations/scenes/scripts while keeping the option
      # to add declarative ones from Nix.
      "automation nixos" = [ ];
      "automation ui" = "!include automations.yaml";
      "scene ui"      = "!include scenes.yaml";
      "script ui"     = "!include scripts.yaml";

      # The go2rtc integration ships inside default_config; it just needs to be
      # told where the server is. Gives camera cards WebRTC (sub-second) instead
      # of HLS (~3s of buffering before the first frame).
      go2rtc.url = "http://127.0.0.1:1984";

      # One list of phones -> notify.garage_alerts. The garage automations call
      # the group, so adding/removing a phone is a one-line change here.
      notify = [
        {
          platform = "group";
          name = "garage_alerts";
          services = [
            { service = "mobile_app_el_dude_2"; }        # Jahan
            { service = "mobile_app_linleys_iphone"; }   # Linley
          ];
        }
      ];
    };
  };

  # HA refuses to start if the !include targets are missing; create them writable.
  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0644 hass hass"
    "f ${config.services.home-assistant.configDir}/scenes.yaml      0644 hass hass"
    "f ${config.services.home-assistant.configDir}/scripts.yaml     0644 hass hass"
  ];

  # ESPHome dashboard — replaces the "ESPHome add-on" the homelab docs assume
  # (HA Core has no Supervisor/add-on store). Reachable at http://<rig>:6052 to
  # flash and adopt garage-door.yaml; after the first flash, updates are OTA.
  services.esphome = {
    enable = true;
    address = "0.0.0.0";   # firewall is off -> reachable on LAN / tailnet
  };
  # esphome >= 2026.8 dropped the built-in `esphome dashboard`; the dashboard
  # now lives in the separate esphome-device-builder package. The NixOS module
  # still execs the old subcommand, so swap the ExecStart until upstream
  # catches up. Same bind address / port / state dir as before.
  systemd.services.esphome = {
    path = [ pkgs.esphome-device-builder ];
    serviceConfig.ExecStart = lib.mkForce (lib.concatStringsSep " " [
      (lib.getExe pkgs.esphome-device-builder)
      "--host ${config.services.esphome.address}"
      "--port ${toString config.services.esphome.port}"
      "/var/lib/esphome"
    ]);
  };

  # Low-latency restreamer for the Reolink camera. Bound to loopback only — HA
  # proxies it, so nothing extra is exposed on the LAN/tailnet.
  services.go2rtc = {
    enable = true;
    settings.api.listen = "127.0.0.1:1984";
  };

  # First USB flash of the ESP8266 (CH340 serial chip) needs dialout access.
  users.users.jahan.extraGroups = [ "dialout" ];
}
