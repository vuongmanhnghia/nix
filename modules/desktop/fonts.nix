{ config, pkgs, ... }:
{
  # Font configuration
  fonts = {
    enableDefaultPackages = true;
    
    packages = with pkgs; [
      # Basic fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      liberation_ttf
      dejavu_fonts
      
      # Programming fonts
      source-code-pro
      fira-code
      fira-code-symbols
      jetbrains-mono
      
      # Vietnamese fonts
      source-han-sans
      source-han-serif
      
      # Additional fonts
      ubuntu_font_family
      google-fonts
      
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" "Source Han Serif" ];
        sansSerif = [ "Noto Sans" "Source Han Sans" ];
        monospace = [ "JetBrains Mono" "Source Code Pro" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
