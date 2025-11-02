{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # mongodb-compass
    # mongodb-tools
    sqlc
    goose
    # beekeeper-studio
  ];

  # nixpkgs.config.permittedInsecurePackages = [
  #   "beekeeper-studio-5.1.5"
  # ];
}