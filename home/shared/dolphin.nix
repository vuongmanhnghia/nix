# 🐬 DOLPHIN FILE MANAGER CONFIGURATION
# Dolphin (KDE File Manager) settings for NixOS
{ config, pkgs, ... }:

let
  # Đường dẫn đến file cấu hình tạm thời (writeable)
  dolphinConfigPath = "${config.home.homeDirectory}/.config/dolphinrc.template";
in
{
  # === DOLPHIN INSTALLATION ===
  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.kio-extras  # Additional protocols support
  ];

  # === DOLPHIN CONFIGURATION TEMPLATE ===
  # Tạo file template thay vì file cấu hình trực tiếp
  home.file.".config/dolphinrc.template".text = ''
    [DetailsMode]
    PreviewSize=32

    [General]
    GlobalViewProps=false
    ShowFullPath=true
    ShowStatusBar=FullWidth
    Version=202

    [KFileDialog Settings]
    Places Icons Auto-resize=false
    Places Icons Static Size=22

    [MainWindow]
    MenuBar=Disabled

    [PreviewSettings]
    Plugins=ffmpegthumbnailer,appimagethumbnail,audiothumbnail,avif,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,heif,imagethumbnail,jpegthumbnail,jxl,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,librsvg,svgthumbnail,ffmpegthumbs,gdk-pixbuf-thumbnailer,gsf-office
  '';

  # === HOME MANAGER ACTIVATION SCRIPT ===
  # Copy template sang file thực khi activate (chỉ nếu chưa tồn tại)
  home.activation.dolphinConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.config/dolphinrc" ]; then
      $DRY_RUN_CMD cp -f "$HOME/.config/dolphinrc.template" "$HOME/.config/dolphinrc"
      $DRY_RUN_CMD chmod 644 "$HOME/.config/dolphinrc"
      echo "Dolphin config initialized from template"
    fi
  '';
}
