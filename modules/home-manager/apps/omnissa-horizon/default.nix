{ config, pkgs, lib, ... }:

let
  omnissaExtracted = pkgs.stdenv.mkDerivation {
    pname = "omnissa-horizon-extracted";
    version = "2506-8.16.0";
    
    src = pkgs.fetchurl {
      url = "https://download3.omnissa.com/software/CART26FQ2_LIN64_DEBPKG_2506/Omnissa-Horizon-Client-2506-8.16.0-16536624989.x64.deb";
      sha256 = "0ngk8imkhhyd5v2d56jkr3affgn5lkz0yw8hxwjs5153jka4qz7j";
    };
    
    nativeBuildInputs = [ pkgs.dpkg ];
    
    unpackPhase = ''
      dpkg-deb -x $src .
    '';
    
    installPhase = ''
      mkdir -p $out
      cp -r usr/* $out/ || true
      cp -r opt/* $out/ || true
    '';
  };
  
  libPath = lib.makeLibraryPath (with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    file
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    libdrm
    libnotify
    libpulseaudio
    libuuid
    libv4l
    libva
    libvdpau
    libxkbcommon
    xorg.libxkbfile
    libxml2
    mesa
    nspr
    nss
    pango
    pcsclite
    stdenv.cc.cc.lib
    systemd
    zlib
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama         # ← THÊM DÒNG NÀY
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxshmfence
  ]);
  
  horizon-wrapper = pkgs.writeShellScriptBin "horizon-client" ''
    #!/usr/bin/env bash
    
    # Create temporary FHS structure
    RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/tmp}/omnissa-horizon-$$"
    mkdir -p "$RUNTIME_DIR"
    
    # Cleanup on exit
    cleanup() {
      rm -rf "$RUNTIME_DIR" 2>/dev/null || true
    }
    trap cleanup EXIT INT TERM
    
    # Create complete FHS directory structure
    mkdir -p "$RUNTIME_DIR/usr/lib/omnissa/horizon/pkcs11"
    mkdir -p "$RUNTIME_DIR/etc/omnissa/udpProxy"
    
    # Copy entire omnissa installation
    cp -r ${omnissaExtracted}/lib/omnissa/* "$RUNTIME_DIR/usr/lib/omnissa/"
    
    # Create empty config file
    touch "$RUNTIME_DIR/etc/omnissa/udpProxy/config"
    
    # Build LD_LIBRARY_PATH
    OMNISSA_LIBS="$RUNTIME_DIR/usr/lib"
    OMNISSA_LIBS="$OMNISSA_LIBS:$RUNTIME_DIR/usr/lib/omnissa"
    OMNISSA_LIBS="$OMNISSA_LIBS:$RUNTIME_DIR/usr/lib/omnissa/horizon"
    OMNISSA_LIBS="$OMNISSA_LIBS:$RUNTIME_DIR/usr/lib/omnissa/horizon/bin"
    OMNISSA_LIBS="$OMNISSA_LIBS:$RUNTIME_DIR/usr/lib/omnissa/horizon/client"
    OMNISSA_LIBS="$OMNISSA_LIBS:$RUNTIME_DIR/usr/lib/omnissa/horizon/vdpService"
    OMNISSA_LIBS="$OMNISSA_LIBS:$RUNTIME_DIR/usr/lib/omnissa/horizon/html5mmr"
    OMNISSA_LIBS="$OMNISSA_LIBS:$RUNTIME_DIR/usr/lib/omnissa/gcc"
    OMNISSA_LIBS="$OMNISSA_LIBS:${omnissaExtracted}/lib"
    OMNISSA_LIBS="$OMNISSA_LIBS:${omnissaExtracted}/lib/pcoip"
    OMNISSA_LIBS="$OMNISSA_LIBS:${omnissaExtracted}/lib/pcoip/vchan_plugins"
    
    export LD_LIBRARY_PATH="$OMNISSA_LIBS:${libPath}:$LD_LIBRARY_PATH"
    
    # GTK/GDK Pixbuf settings
    export GDK_PIXBUF_MODULE_FILE="${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
    export GDK_PIXBUF_MODULEDIR="${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    
    # GTK theme and icons
    export GTK_THEME=Adwaita:dark
    export GTK_DATA_PREFIX=${pkgs.gtk3}
    export XDG_DATA_DIRS="${pkgs.gtk3}/share:${pkgs.gsettings-desktop-schemas}/share:${pkgs.hicolor-icon-theme}/share:$XDG_DATA_DIRS"
    
    # Force X11 via XWayland
    export GDK_BACKEND=x11
    export QT_QPA_PLATFORM=xcb
    
    # Auto-detect DISPLAY for XWayland
    if [ -z "$DISPLAY" ]; then
      # Try common XWayland displays
      for display in :0 :1 :2; do
        if [ -e "/tmp/.X11-unix/X''${display#:}" ]; then
          export DISPLAY=$display
          break
        fi
      done
    fi
    
    # Fallback
    export DISPLAY=''${DISPLAY:-:0}
    
    # Run from runtime directory
    cd "$RUNTIME_DIR"
    exec "$RUNTIME_DIR/usr/lib/omnissa/horizon/bin/horizon-client" "$@"
  '';
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [ horizon-wrapper ];
}