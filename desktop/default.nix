{ config, pkgs, ... }:

{
  # Desktop environment configuration modules
  imports = [
    ./display.nix  # Display manager configuration
    ./hyprland.nix # Hyprland window manager (basic setup)
    ./audio.nix    # PipeWire audio system with low-latency configuration
    ./graphics.nix # NVIDIA graphics drivers and GPU support
    ./fonts.nix    # System fonts and font configuration
  ];
} 