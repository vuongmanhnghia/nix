{
  config,
  pkgs,
  lib,
  ...
}:

let
  bongocat = pkgs.appimageTools.wrapType2 rec {
    pname = "bongocat";
    version = "0.8.2";

    src = fetchurl {
      url = "https://github.com/ayangweb/BongoCat/releases/download/v${version}/BongoCat_${version}_amd64.AppImage";
      sha256 = "sha256-1vn3FsUkCx3EQmASZnLnTON0NWavt41Pn2Pi/Eswkcg=";
    };

    meta = with lib; {
      description = "Bongo Cat";
      homepage = "";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };

  bongocatDesktopItem = pkgs.makeDesktopItem {
    name = "bongocat";
    desktopName = "Bongo Cat";
    exec = "bongocat";
    icon = "bongocat";
    terminal = false;
    categories = [ "Development" ];
    startupWMClass = "bongocat";
  };
in
{
  home.packages = with pkgs; [
    bongocat
    bongocatDesktopItem
  ];
}
