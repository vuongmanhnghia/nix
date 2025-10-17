# 🗂️ NEMO FILE MANAGER CONFIGURATION
# Nemo (Cinnamon File Manager) settings for NixOS
{ config, pkgs, ... }:

{
  # === NEMO CONFIGURATION ===
  # Nemo is already installed in desktop/hyprland.nix
  
  # === XDG MIME ASSOCIATIONS ===
  # Set Nemo as default file manager for directory/folder types
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "nemo.desktop";
      "application/x-gnome-saved-search" = "nemo.desktop";
    };
  };

  # === NEMO DConf SETTINGS ===
  # Configure Nemo preferences using dconf
  dconf.settings = {
    "org/nemo/preferences" = {
      show-hidden-files = false;
      show-image-thumbnails = "always";
      thumbnail-limit = 10485760; # 10MB
      quick-renames-with-pause-in-between = true;
    };

    "org/nemo/window-state" = {
      sidebar-width = 200;
      geometry = "900x600+0+0";
    };

    "org/nemo/list-view" = {
      default-visible-columns = ["name" "size" "type" "date_modified"];
      default-column-order = ["name" "size" "type" "date_modified" "date_created" "owner" "group" "permissions"];
    };
  };
}
