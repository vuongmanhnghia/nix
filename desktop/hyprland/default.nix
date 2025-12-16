{ config, pkgs, ... }:

{
  imports = [
    ./core.nix
    ./utilities.nix
    ./theming.nix
  ];

  # Additional tools and utilities
  environment.systemPackages = with pkgs; [
    # === SHELL AND PROMPT ===
    starship          # Cross-shell prompt
    oh-my-posh        # Prompt theme engine
    eza               # Modern ls replacement
  ];
}
