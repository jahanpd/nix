{ pkgs, config, lib, home-manager, ... }: {
  imports = [
    ../configs/hypr.nix
    ../basehome.nix
  ];
  home.packages = [
  ];
}
