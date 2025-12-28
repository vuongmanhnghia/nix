{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sqlc                # SQL compiler - generates type-safe code from SQL
    goose               # Database migration tool
    beekeeper-studio    # Database management GUI
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.3.4"
  ];
}