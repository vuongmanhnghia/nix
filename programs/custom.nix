{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    (appimageTools.wrapType2 rec {
      pname = "beekeeper-studio";
      version = "5.4.9";
      src = fetchurl {
        url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/Beekeeper-Studio-${version}.AppImage";
        sha256 = "sha256-E6zLx/ayTOcPNsFz34r/86dj3eeQsZDvE/o/HSYlD4U=";
      };
      meta = with lib; {
        description = "A modern, lightweight, and fast SQL client for macOS, Windows, and Linux.";
        homepage = "https://beekeeperstudio.io/";
        license = licenses.unfree;
        platforms = platforms.linux;
        maintainers = [ ];
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      };
    })

    # (appimageTools.wrapType2 rec {
    #   pname = "warp-terminal-latest";
    #   version = "0.2025.09.24.08.11.stable_03";
    #   src = pkgs.fetchurl {
    #     url = "https://releases.warp.dev/stable/v0.2025.10.29.08.12.stable_03/Warp-x86_64.AppImage";
    #     hash = "sha256-akshB2IV2Zya1VO8yuX4w5u/iPiKNTeWuZbeW3/f2jg=";
    #   }; 
    #   extraPkgs = pkgs: with pkgs; [
    #     libGL
    #     libpulseaudio
    #     vulkan-loader
    #   ];
    # })
  ];
}

