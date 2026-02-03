{ config, lib, pkgs, hostVars, ... }:

{
  # === SYSTEM-LEVEL FCITX5 CONFIGURATION ===
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-unikey
      ];
    };
  };

  # === ENVIRONMENT VARIABLES ===
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "fcitx";
    FCITX_ENABLE_WAYLAND = "1";
  };

  # === HOME-MANAGER CONFIGURATION ===
  home-manager.users.${hostVars.user.username} = {
    home.file = {
      ".config/fcitx5/config" = {
        force = true;  
        text = ''
          [Hotkey]
          TriggerKeys=
          EnumerateWithTriggerKeys=True
          EnumerateSkipFirst=False

          [Hotkey/TriggerKeys]
          0=Control+Super+space

          [Behavior]
          ActiveByDefault=False
          ShareInputState=No
          PreeditEnabledByDefault=True
          ShowInputMethodInformation=False
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
          DefaultInputMethodState=Inactive
        '';
      };

      # FCITX5 Profile - EXPLICIT UNIKEY SETUP
      ".config/fcitx5/profile" = {
        force = true; 
        text = ''
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
      };

      # THÊM: Addon configuration để force enable unikey
      ".config/fcitx5/conf/addon.conf" = {
        force = true; 
        text = ''
          [Addons]
          # Core addons
          keyboard=True
          waylandim=True
          xcb=True
          clipboard=True
          unicode=True
          quickphrase=True
          classicui=True
          notifications=True
          
          # Vietnamese input
          unikey=True
          
          # Optional addons
          fullwidth=False
          halfwidth=False
          punctuation=False
          spell=False
        '';
      };

      # Unikey Configuration
      ".config/fcitx5/conf/unikey.conf" = {
        force = true;  
        text = ''
          InputMethod=Telex
          OutputCharset=Unicode
          ProcessWAtWordBeginning=True
          SpellCheck=False
          MacroEnabled=True
          MouseCapture=True
        '';
      };

      # UI Configuration
      ".config/fcitx5/conf/classicui.conf" = {
        force = true;
        text = ''
          Vertical Candidate List=False
          WheelForPaging=True
          Font="Rubik 11"
          MenuFont="Rubik 11"
          TrayFont="Rubik 11"
          PreferTextIcon=True
          ShowLayoutNameInIcon=True
          UseInputMethodLanguageToDisplayText=True
          Theme=default
          UseDarkTheme=True
          UseAccentColor=True
          PerScreenDPI=False
          ForceWaylandDPI=0
          EnableFractionalScale=True
        '';
      };

      # Notifications
      ".config/fcitx5/conf/notifications.conf" = {
        force = true; 
        text = ''
          HiddenNotifications=
        '';
      };

      # THÊM: Global Config để enforce default behavior
      ".config/fcitx5/conf/globalconfig.conf" = {
        force = true; 
        text = ''
          [Hotkey]
          TriggerKeys=
          EnumerateWithTriggerKeys=True
          EnumerateSkipFirst=False

          [Hotkey/TriggerKeys]
          0=Control+space

          [Behavior]
          ActiveByDefault=False
          ShareInputState=No
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
          DefaultInputMethodState=Inactive
        '';
      };
    };

    # AUTOSTART - Sử dụng home-manager's built-in functionality
    xdg.configFile."autostart/fcitx5.desktop" = {
      force = true;  
      text = ''
        [Desktop Entry]
        Name=Fcitx 5
        GenericName=Input Method
        Comment=Start Input Method
        Exec=fcitx5 -d
        Icon=fcitx
        Terminal=false
        Type=Application
        Categories=System;Utility;
        StartupNotify=false
        X-GNOME-Autostart-Phase=Applications
        X-GNOME-AutoRestart=false
        X-GNOME-Autostart-Notify=false
        X-KDE-autostart-after=panel
        Hidden=false
      '';
    };
  };
}
