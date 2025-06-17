{ config, pkgs, ... }:

{
  # X11 configuration
  services.xserver = {
    enable = true;
    
    # Keyboard configuration
    xkb = {
      layout = "us,vn";
      options = "grp:alt_shift_toggle,compose:ralt";
    };
    
    # Display configuration - sẽ được ghi đè bởi display manager
    displayManager.sessionCommands = ''
      # Tự động detect và apply custom refresh rates
      
      # For high refresh rate monitors (144Hz, 165Hz, 180Hz)
      if ${pkgs.xorg.xrandr}/bin/xrandr | grep -q "2560x1440"; then
        # 1440p 180Hz custom mode
        ${pkgs.xorg.xrandr}/bin/xrandr --newmode "2560x1440_180.00" 685.25 2560 2792 3072 3584 1440 1443 1453 1493 -hsync +vsync 2>/dev/null || true
        ${pkgs.xorg.xrandr}/bin/xrandr --addmode DP-1 "2560x1440_180.00" 2>/dev/null || true
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --mode "2560x1440_180.00" --primary 2>/dev/null || true
      fi
      
      if ${pkgs.xorg.xrandr}/bin/xrandr | grep -q "1920x1080"; then
        # 1080p 144Hz for RTX 3050 Ti laptops
        ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode "1920x1080" --rate 144 --primary 2>/dev/null || true
      fi
    '';

    # Display Manager và Desktop Environment
    displayManager.gdm = {
      enable = true;
      wayland = true;  # Enable Wayland by default
      autoSuspend = false;  # Prevent auto-suspend for gaming/workstation use
    };
    
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        # GNOME performance optimizations
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
        
        # Disable animations for better performance
        [org.gnome.desktop.interface]
        enable-animations=false
        
        # Night light settings
        [org.gnome.settings-daemon.plugins.color]
        night-light-enabled=true
        night-light-temperature=4000
      '';
    };

    # X11 security và performance settings
    serverLayoutSection = ''
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
      Option "BlankTime" "0"
    '';
  };

  # Libinput configuration (updated for NixOS 25.05)
  services.libinput = {
    enable = true;
    
    # Touchpad configuration (laptop)
    touchpad = {
      accelSpeed = "0.2";
      accelProfile = "adaptive";
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      scrollMethod = "twofinger";
      clickMethod = "clickfinger";  # Better for modern trackpads
      horizontalScrolling = true;
    };
    
    # Mouse configuration (desktop/external mouse)
    mouse = {
      accelSpeed = "0";
      accelProfile = "flat";  # Better for gaming/precision work
      naturalScrolling = false;
      middleEmulation = false;
      scrollMethod = "button";
      disableWhileTyping = false;
      tapping = false;
    };
  };

  # Font rendering optimization
  fonts = {
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel = {
        lcdfilter = "default";
        rgba = "rgb";
      };
    };
  };

  # Gaming và multimedia optimization
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  # Audio latency optimization (cho gaming)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Low-latency configuration
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };
  };

  # Additional X11 packages
  environment.systemPackages = with pkgs; [
    # X11 utilities
    xorg.xrandr
    xorg.xdpyinfo
    xorg.xwininfo
    xorg.xprop
    
    # Gaming utilities
    gamemode
    gamescope
    
    # Performance monitoring
    glxinfo
    mesa-demos
  ];

  # Enable hardware cursors for better performance
  environment.sessionVariables = {
    # Cursor theme and size
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    
    # X11 performance
    CLUTTER_BACKEND = "x11";
    
    # Gaming optimizations
    __GL_THREADED_OPTIMIZATIONS = "1";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
  };
}
