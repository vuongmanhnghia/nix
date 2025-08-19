{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mongodb-compass
    mongodb-tools
    sqlc
    goose
  ];
}