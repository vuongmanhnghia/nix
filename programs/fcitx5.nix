{ config, lib, pkgs, ... }:

{
  # === CLEAN FCITX5 CONFIGURATION ===
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-unikey          # Vietnamese input method
        fcitx5-gtk             # GTK integration
        libsForQt5.fcitx5-qt   # Qt5 integration
        qt6Packages.fcitx5-qt  # Qt6 integration  
        fcitx5-configtool      # Configuration tool
        fcitx5-with-addons     # Additional addons
      ];
    };
  };

  # === SYSTEM PACKAGES ===
  
  # === ENVIRONMENT VARIABLES ===
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    # SỬA: Thống nhất dùng fcitx thay vì ibus
    GLFW_IM_MODULE = "fcitx";
    
    FCITX_ENABLE_WAYLAND = "1";
  };

  # === FCITX5 CONFIG - SỬA LỖI ===
  # Chuyển sang dùng home-manager để cấu hình fcitx5
  home-manager.users.nagih.xdg.configFile = {
    "fcitx5/config".text = ''
      [Hotkey]
      TriggerKeys=
      EnumerateWithTriggerKeys=True
      EnumerateSkipFirst=False

      [Hotkey/TriggerKeys]
      0=Control+space
      1=Zenkaku_Hankaku
      2=Hangul

      [Behavior]
      ActiveByDefault=True
      # Quan trọng: Để per-application input method
      ShareInputState=False
      PreeditEnabledByDefault=True
      ShowInputMethodInformation=True
      showInputMethodInformationWhenFocusIn=False
      CompactInputMethodInformation=True
      ShowFirstInputMethodInformation=True
      DefaultPageSize=5
      OverrideXkbOption=False
      CustomXkbOption=
      EnabledAddons=
      DisabledAddons=
      PreloadInputMethod=True
      AllowInputMethodForPassword=False
      PreeditInApplication=True
      # SỬA: Đặt default state là Active
      DefaultInputMethodState=Active
    '';

    "fcitx5/profile".text = ''
      [Groups/0]
      Name=Default
      Default Layout=us
      DefaultIM=keyboard-us

      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=us

      [Groups/0/Items/1]
      Name=unikey
      Layout=us

      [GroupOrder]
      0=Default
    '';

    "fcitx5/conf/unikey.conf".text = ''
      # Input Method
      InputMethod=Telex
      # Output Charset
      OutputCharset=Unicode
      # Process W at word beginning
      ProcessWAtWordBeginning=True
      # Spellcheck
      SpellCheck=False
      # Macro enabled
      MacroEnabled=True
      # Mouse Capture
      MouseCapture=True
    '';

    "fcitx5/conf/classicui.conf".text = ''
      # Vertical Candidate List
      Vertical Candidate List=False
      # Use mouse wheel to go to prev or next page
      WheelForPaging=True
      # Font
      Font="Rubik 11"
      # Menu Font
      MenuFont="Rubik 11"
      # Tray Font
      TrayFont="Rubik 11"
      # Prefer Text Icon
      PreferTextIcon=False
      # Show Layout Name In Icon
      ShowLayoutNameInIcon=True
      # Use input method language to display text
      UseInputMethodLanguageToDisplayText=True
      # Theme
      Theme=plasma
      # Follow system light/dark color scheme
      UseDarkTheme=True
      # Use accent color if it is supported by theme and desktop
      UseAccentColor=True
      # Use Per Screen DPI on X11
      PerScreenDPI=False
      # Force font DPI on Wayland
      ForceWaylandDPI=0
      # Enable fractional scale under Wayland
      EnableFractionalScale=True
    '';

    "fcitx5/conf/notifications.conf".text = ''
      HiddenNotifications=
    '';
  };

  # === SYSTEMD SERVICE - ĐƯỢC CẢI THIỆN ===
  systemd.user.services.fcitx5-daemon = {
    description = "Fcitx5 input method editor";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    
    environment = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
      GLFW_IM_MODULE = "fcitx";  # SỬA: Thống nhất
      FCITX_ENABLE_WAYLAND = "1";
      XDG_CONFIG_HOME = "%h/.config";
    };
    
    serviceConfig = {
      Type = "dbus";
      BusName = "org.fcitx.Fcitx5";
      ExecStart = "${pkgs.fcitx5}/bin/fcitx5";
      ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
      Restart = "on-failure";
      RestartSec = 3;
      # THÊM: Đảm bảo service chạy sau khi desktop environment sẵn sàng
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
    };
  };

  # === DBUS CONFIGURATION ===
  services.dbus.packages = with pkgs; [ fcitx5 ];
  
  # === THÊM: ĐẢM BẢO FCITX5 AUTOSTART ===
  # Chuyển sang dùng home-manager để cấu hình autostart
  home-manager.users.nagih.xdg.configFile."autostart/fcitx5.desktop".text = ''
    [Desktop Entry]
    Name=Fcitx 5
    GenericName=Input Method
    Comment=Start Input Method
    Exec=fcitx5
    Icon=fcitx
    Terminal=false
    Type=Application
    Categories=System;Utility;
    StartupNotify=false
    X-GNOME-Autostart-Phase=Applications
    X-GNOME-AutoRestart=false
    X-GNOME-Autostart-Notify=false
    X-KDE-autostart-after=panel
  '';
}