# ~/.config/nixpkgs/home.nix - Updated for NixOS 25.05
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # IntelliJ IDEA Community
    jetbrains.idea-community
    
    # Java (latest stable)
    jdk
    gradle
  ];

  # Environment variables for manual SDK setup
  home.sessionVariables = {
    ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";
    JAVA_HOME = "${pkgs.jdk}/lib/openjdk";
    PATH = "${config.home.homeDirectory}/Android/Sdk/platform-tools:${config.home.homeDirectory}/Android/Sdk/cmdline-tools/latest/bin:$PATH";
  };
}