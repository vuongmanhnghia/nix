{ config, pkgs, ... }:

{
  # Desktop environment configuration modules
  imports = [
    ./hyprland # Hyprland window manager (basic setup)
    ./display.nix  # Display manager configuration
    ./audio.nix    # PipeWire audio system with low-latency configuration
    ./graphics.nix # NVIDIA graphics drivers and GPU support
    ./fonts.nix    # System fonts and font configuration
  ];
} 