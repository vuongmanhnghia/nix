{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nix-bash-completions    # Nix-specific bash completions
    nix-index               # Fast file and package search for Nix
    comma                   # Command-not-found handler for Nix
  ];
}