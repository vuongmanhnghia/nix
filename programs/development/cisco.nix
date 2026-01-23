{ pkgs ? import <nixpkgs> {} }:

let
  pname = "cisco-packet-tracer";
  version = "9.0.0";
  
  coccoc-src = pkgs.stdenv.mkDerivation {
    name = "${pname}-source";
    src = pkgs.fetchurl {
      url = "https://prod-tf-ui.s3.amazonaws.com/s/ff9e491c-49be-4734-803e-a79e6e83dab1/resources/9accb7fd-7560-45c6-b6de-9ab7e9cf07b8/v1/en-US/CiscoPacketTracer_900_Ubuntu_64bit.deb?response-cache-control=no-cache&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260121T103234Z&X-Amz-SignedHeaders=host&X-Amz-Credential=AKIAUJZRIEYBD5LJIEBJ%2F20260121%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Expires=30&X-Amz-Signature=557186476610616c496c833183b6f4b14068608c2d67669a281a97a9114a8f5f";
      sha256 = "0diqr1jvxxmfl32aa8d643b45v8irxjv6hra89ms50bc9c71rsi1"; 
    };
    
    nativeBuildInputs = [ pkgs.dpkg ];
    
    unpackPhase = ''
      dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    '';

    installPhase = ''
      mkdir -p $out
      cp -r usr/* $out/
      # Copy opt directory if exists
      if [ -d opt ]; then
        mkdir -p $out/opt
        cp -r opt/* $out/opt/
      fi
    '';
  };

in pkgs.buildFHSEnv {
  name = "cisco-packet-tracer";
  
  targetPkgs = pkgs: with pkgs; [
    # Qt dependencies
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qtnetworkauth
    qt5.qtscript
    qt5.qtwebengine
    qt5.qtwebsockets
    
    # System libraries
    glib
    fontconfig
    freetype
    zlib
    libglvnd
    libGL
    libGLU
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    
    # Audio
    alsa-lib
    libpulseaudio
    
    # Other dependencies
    dbus
    icu
    openssl
    libxkbcommon
    libdrm
    mesa
    
    # Standard utilities
    coreutils
    bash
  ];
  
  multiPkgs = pkgs: with pkgs; [
    # 32-bit compatibility if needed
  ];
  
  profile = ''
    export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins/platforms"
    export QT_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins"
    export LD_LIBRARY_PATH="${coccoc-src}/opt/pt/lib:$LD_LIBRARY_PATH"
  '';
  
  runScript = pkgs.writeShellScript "cisco-packet-tracer" ''
    exec ${coccoc-src}/opt/pt/bin/PacketTracer "$@"
  '';
  
  meta = with pkgs.lib; {
    description = "Cisco Packet Tracer network simulation tool";
    homepage = "https://www.netacad.com/courses/packet-tracer";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}