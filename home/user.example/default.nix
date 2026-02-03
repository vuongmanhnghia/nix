{ config, pkgs, unstable, inputs, hostVars, ... }:

{
  home.username = hostVars.user.username;            
  home.homeDirectory = "/home/${hostVars.user.username}"; 
  home.stateVersion = hostVars.nix_version;
  
  imports = [
    # Desktop
    ../../modules/home-manager/desktop/hyprland
    ../../modules/home-manager/desktop/xdg-portal

    # Features
    ../../modules/home-manager/features/quickshell
    ../../modules/home-manager/features/zsh
    ../../modules/home-manager/features/nvim
    ../../modules/home-manager/features/wezterm
    ../../modules/home-manager/features/tmux
    ../../modules/home-manager/features/git
    ../../modules/home-manager/features/mpv
    ../../modules/home-manager/features/nemo
    ../../modules/home-manager/features/fastfetch
    ../../modules/home-manager/features/ripgrep
    ../../modules/home-manager/features/starship
    
    # GUI
    ../../modules/home-manager/gui/cursor
    ../../modules/home-manager/gui/fontconfig
    ../../modules/home-manager/gui/gtk-theme
    ../../modules/home-manager/gui/kde
    ../../modules/home-manager/gui/kvantum
    ../../modules/home-manager/gui/matugen
    ../../modules/home-manager/gui/qt5ct
    ../../modules/home-manager/gui/qt6ct      
  ];  

  programs.git = {
    settings = {
      user = {
        name = hostVars.git_name;               
        email = hostVars.git_email;
      };
    };
  };

  home.packages = with pkgs; [
    unstable.spotify                  
    unstable.vscode                   
  ];

  home.shellAliases = hostVars.alias;
  services.syncthing = hostVars.syncthing;
}
