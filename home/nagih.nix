{ config, pkgs, ... }:

{
  imports = [ ./default.nix ];

  # User info
  home.username = "nagih";
  home.homeDirectory = "/home/nagih";
  home.stateVersion = "25.05";

  # User-specific Git config
  programs.git = {
    userName = "Nagih";
    userEmail = "vuongmanhnghia@gmail.com";
  };

  # User-specific packages
  home.packages = with pkgs; [
    # Development
    docker-compose
   
    # Personal apps
    google-chrome
    discord
    spotify
    code-cursor
    
    # Steam management
    steam
    steam-run
    protonup-qt # Tool để quản lý Proton versions
    winetricks   # Tool hỗ trợ Wine/Proton
    
    # Personal tools
    obsidian
    obs-studio
  ];
  
  # Đồng bộ dữ liệu qua Syncthing
  services.syncthing = {
    enable = true;
    
    settings = {
      # Cấu hình GUI
      gui = {
        address = "127.0.0.1:8384";  # Hoặc "0.0.0.0:8384" để truy cập từ xa
        user = "Nagih";
        password = "Vmn.2005"; 
      };
      
      devices = {
        "laptop" = { id = "YOUR-DEVICE-ID"; };
        "desktop" = { id = "ABLZ4HZ-4LT6U5O-KLDDQO7-WTCX3KQ-CJBPT73-666IPZJ-UALV3FO-GEG5DQU"; };
      };
      
      # Cấu hình thư mục đồng bộ
      folders = {
        "Documents" = {
          id = "documents";
          path = "/home/nagih/Documents";
          devices = [ "laptop" "desktop" ];
          versioning = {
            type = "simple";
            params = {
              keep = "10";  # Giữ 10 phiên bản cũ
            };
          };
        };
        
        "Photos" = {
          id = "photos";
          path = "/home/nagih/Pictures/Sync";
          devices = [ "desktop" "laptop" ];
          # Chỉ nhận file, không gửi
          type = "receiveonly";
        };

        "Workspaces" = {
          id = "workspaces";
          path = "/home/nagih/Workspaces/Dev/vscode-workspaces";
          devices = ["desktop" "laptop"];
        };
      };
      
      # Các options khác
      options = {
        globalAnnounceEnabled = true;
        localAnnounceEnabled = true;
        relaysEnabled = true;
      };
    };
  };
  
  # Tạo thư mục cần thiết (nếu chưa tồn tại)
  home.activation.createSyncthingDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p $HOME/Documents
    mkdir -p $HOME/Pictures/Sync
  '';
  
  # Kích hoạt GameMode (tùy chọn, tăng performance)
  # programs.gamemode.enable = true;
  
  # Cấu hình cho node
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Custom aliases for this user
  programs.bash.shellAliases = {
    dev = "cd ~/Workspaces/Dev";
    web = "cd ~/Workspaces/Dev/Web";
    app = "cd ~/Workspaces/Dev/App";
  };
}
