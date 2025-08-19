# home/shared/ripgrep.nix - Home Manager configuration for ripgrep
{ config, pkgs, ... }:

{
  # Cài đặt ripgrep
  home.packages = with pkgs; [
    fuzzel
  ];

  # Tạo file cấu hình foot
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    include="~/.config/fuzzel/fuzzel_theme.ini"
    font=Gabarito
    terminal=kitty -1
    prompt=">>  "
    layer=overlay

    [border]
    radius=17
    width=1

    [dmenu]
    exit-immediately-if-empty=yes
  '';

  # Tạo file cấu hình theme
  xdg.configFile."fuzzel/fuzzel_theme.ini".text = ''
    [colors]
    background=161217ff
    text=e9e0e8ff
    selection=4b454dff
    selection-text=cdc3ceff
    border=4b454ddd
    match=dfb8f6ff
    selection-match=dfb8f6ff
  '';
}