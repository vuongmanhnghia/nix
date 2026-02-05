{ config, pkgs, quickshell, ... }:

{
  # === SYSTEMD USER SERVICES ===
  systemd.user.services = {
    # Ydotool daemon
    ydotool = {
      Unit = {
        Description = "Ydotool daemon";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Ollama AI service
    ollama = {
      Unit = {
        Description = "Ollama AI Service";
        After = [ "network.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.ollama}/bin/ollama serve";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    # Cliphist
    cliphist-watch = {
      Unit = {
        Description = "Clipboard history watcher";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store'";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # SWWW Wallpaper daemon
    swww = {
      Unit = {
        Description = "SWWW wallpaper daemon";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        ExecStartPost = "${pkgs.bash}/bin/bash -c '${pkgs.swww}/bin/swww init'";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
    
    # Matugen theme service
    matugen-startup = {
      Unit = {
        Description = "Apply Material You theme on startup";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.matugen}/bin/matugen image ${config.home.homeDirectory}/Pictures/Wallpapers/default.png -a'";
        Restart = "no";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
} 