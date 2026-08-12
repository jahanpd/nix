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

  # First USB flash of the ESP8266 (CH340 serial chip) needs dialout access.
  users.users.jahan.extraGroups = [ "dialout" ];
}
