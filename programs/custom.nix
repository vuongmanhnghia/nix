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

    (appimageTools.wrapType2 rec {
      pname = "cisco-packet-tracer";
      version = "9.0.0";
      
      src = /home/nagih/Documents/packages/CiscoPacketTracer/packettracer.AppImage;

      extraPkgs = pkgs: with pkgs; [
        libpng
        libxkbfile

        qt5.qtbase
        qt5.qtmultimedia  
        
        libxcb
        xcb-util-cursor
        # xcb-util-image
        # xcb-util-keysyms
        # xcb-util-renderutil
        # xcb-util-wm

        libGL
        libdrm
        mesa

        dbus
        fontconfig
        freetype
      ];

      extraInstallCommands = 
        let
          contents = pkgs.appimageTools.extractType2 {
            name = "cisco-packet-tracer";
            src = /home/nagih/Documents/packages/CiscoPacketTracer/packettracer.AppImage;
          };
        in ''
          # Thêm makeWrapper vào PATH
          source ${pkgs.makeWrapper}/nix-support/setup-hook
          
          wrapProgram $out/bin/cisco-packet-tracer \
            --set QT_QPA_PLATFORM xcb \
            --prefix QT_PLUGIN_PATH : "${pkgs.qt5.qtbase}/${pkgs.qt5.qtbase.qtPluginPrefix}"
        '';
      
      meta = with lib; {
        description = "Cisco Packet Tracer - Network simulation tool";
        homepage = "https://www.netacad.com/courses/packet-tracer";
        license = licenses.unfree;
        platforms = [ "x86_64-linux" ];
      };
    })
  ];
}

