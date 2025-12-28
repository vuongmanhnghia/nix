{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # (appimageTools.wrapType2 rec {
    #   pname = "beekeeper-studio";
    #   version = "5.4.9";
      
    #   src = fetchurl {
    #     url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/Beekeeper-Studio-${version}.AppImage";
    #     sha256 = "sha256-E6zLx/ayTOcPNsFz34r/86dj3eeQsZDvE/o/HSYlD4U=";
    #   };
      
    #   meta = with lib; {
    #     description = "Modern SQL client";
    #     homepage = "https://beekeeperstudio.io/";
    #     license = licenses.unfree;
    #     platforms = platforms.linux;
    #   };
    # })

    # (appimageTools.wrapType2 rec {
    #   pname = "bongocat";
    #   version = "0.8.2";
      
    #   src = fetchurl {
    #     url = "https://github.com/ayangweb/BongoCat/releases/download/v${version}/BongoCat_${version}_amd64.AppImage";
    #     sha256 = "sha256-1vn3FsUkCx3EQmASZnLnTON0NWavt41Pn2Pi/Eswkcg=";
    #   };
      
    #   meta = with lib; {
    #     description = "Bongo Cat";
    #     homepage = "";
    #     license = licenses.unfree;
    #     platforms = platforms.linux;
    #   };
    # })
  ];
}

