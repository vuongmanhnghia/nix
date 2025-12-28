{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libnotify,
  libpulseaudio,
  libuuid,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  xdg-utils,
  xorg,
  wayland,
  snappy,
  libva,
  vulkan-loader,
}:

stdenv.mkDerivation rec {
  pname = "coccoc-browser";
  version = "141.0.7390.132-1";

  src = fetchurl {
    url = "https://browser-linux.coccoc.com/deb/pool/main/coccoc-browser-stable_${version}_amd64.deb";
    sha256 = "0diqr1jvxxmfl32aa8d643b45v8irxjv6hra89ms50bc9c71rsi1"; # Thay bằng hash thực
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    libpulseaudio
    libuuid
    libva
    libxkbcommon
    mesa
    nspr
    nss
    pango
    pipewire
    snappy
    vulkan-loader
    wayland
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxshmfence
  ];

  runtimeDependencies = [
    systemd
  ];

  # Bỏ qua Qt shim libraries - chúng là optional cho file dialogs
  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r opt/coccoc $out/opt/

    # Copy share directory
    mkdir -p $out/share
    cp -r usr/share/* $out/share/

    # Xóa chrome-sandbox (sẽ dùng namespace sandbox)
    rm -f $out/opt/coccoc/browser/chrome-sandbox

    # Xóa Qt shim files (optional, dùng cho native file dialogs)
    # Browser vẫn hoạt động bình thường với GTK dialogs
    rm -f $out/opt/coccoc/browser/libqt5_shim.so
    rm -f $out/opt/coccoc/browser/libqt6_shim.so

    # Binary chính là ./opt/coccoc/browser/browser
    mkdir -p $out/bin
    makeWrapper $out/opt/coccoc/browser/browser $out/bin/coccoc-browser \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    # Tạo symlink cho compatibility
    ln -s $out/bin/coccoc-browser $out/bin/coccoc-browser-stable

    # Sửa .desktop file
    substituteInPlace $out/share/applications/coccoc-browser.desktop \
      --replace-fail "/usr/bin/coccoc-browser-stable" "$out/bin/coccoc-browser"

    # Symlink icons
    for size in 16 24 32 48 64 128 256; do
      if [ -f "$out/opt/coccoc/browser/product_logo_$size.png" ]; then
        mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
        ln -s $out/opt/coccoc/browser/product_logo_$size.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/coccoc-browser.png
      fi
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cốc Cốc Browser - Trình duyệt web của Việt Nam";
    homepage = "https://coccoc.com";
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "coccoc-browser";
  };
}
