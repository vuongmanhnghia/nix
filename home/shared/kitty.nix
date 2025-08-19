{ config, lib, ... }:

{
  programs.kitty = {
    enable = true;
    
    font = {
      name = "JetBrainsMono NF Bold";
      size = 14.0;
    };
    
    settings = {
      # Font settings
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # Window settings - Transparent background
      background_opacity = "0.7";
      background_blur = 15;
      background_image = "none";
      background_tint = "0.8";
      confirm_os_window_close = 0;
      window_padding_width = 4;
      window_margin_width = 4;

      # Cursor settings
      cursor_trail = 1;

      # Display server
      linux_display_server = "auto";

      # Scrolling
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;

      # Audio
      enable_audio_bell = false;

      # Additional transparency settings
      dynamic_background_opacity = true;
      background_image_layout = "scaled";

      extraConfig = ''
        # Import color scheme
        include /home/nagih/Workspaces/Config/nixos/colors/kitty.conf
      '';
    };
  };
}