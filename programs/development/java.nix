# /etc/nixos/configuration.nix - Updated for NixOS 25.05
{ config, pkgs, lib, ... }:

{
  # Android development packages
  environment.systemPackages = with pkgs; [
    # IntelliJ IDEA Community Edition
    jetbrains.idea-community
    
    # Android SDK và tools
    # android-tools   # adb, fastboot, etc.

    # androidenv.androidPkgs.tools
    # androidenv.androidPkgs.platform-tools
    # androidenv.androidPkgs.emulator
    # androidenv.androidPkgs.androidsdk
    
    # Java Development Kit (latest stable)
    # jdk            
    
    # Build tools
    # gradle
    
    # Emulator dependencies
    # qemu
    # libGL
    
    # System libraries for emulator
    # stdenv.cc.cc.lib
    # zlib
    # ncurses5
    
    # USB debugging support
    # usbutils
  ];

  # Enable Android development
  # programs.adb.enable = true;

  # Hardware acceleration và virtualization
  # virtualisation.libvirtd.enable = true;
  # boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

  # USB debugging rules
  # services.udev.packages = [ pkgs.android-udev-rules ];

  # Environment variables for development
  # environment.variables = {
  #   JAVA_HOME = "${pkgs.jdk}/lib/openjdk";
  # };
}