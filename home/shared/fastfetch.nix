{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
  ];

  # Tạo file cấu hình fastfetch trong ~/.config/fastfetch/
  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "source": "nixos_small",
        "padding": {
          "top": 1,
          "left": 2
        }
      },
      "display": {
        "separator": " "
      },
      "modules": [
        "break",
        "title",
        {
          "type": "os",
          "key": "os "
        },
        {
          "type": "wm", 
          "key": "de "
        },
        {
          "type": "packages",
          "format": "{} (nix-store)",
          "key": "pkgs "
        },
        {
          "type": "shell",
          "key": "shell "
        },
        {
          "type": "kernel",
          "key": "kernel"
        },
        {
          "type": "uptime",
          "format": "{2}h {3}m",
          "key": "uptime"
        },
        {
          "type": "command",
          "key": "generation",
          "text": "nixos-rebuild list-generations | tail -1 | awk '{print \"Gen \" $1 \" (\" $2 \" \" $3 \")\"}'"
        },
        {
          "type": "command",
          "key": "os age", 
          "text": "if [ -f /etc/NIXOS ]; then birth_install=$(stat -c %W /etc/NIXOS 2>/dev/null || stat -c %Y /etc/NIXOS); else birth_install=$(stat -c %W / 2>/dev/null || stat -c %Y /); fi; current=$(date +%s); days_difference=$(( (current - birth_install) / 86400 )); echo $days_difference days"
        },
        {
          "type": "memory",
          "key": "memory"
        },
        "break",
        {
          "type": "colors", 
          "symbol": "circle"
        },
        "break"
      ]
    }
  '';

  home.shellAliases = {
    ff = "fastfetch";
    neofetch = "fastfetch"; # thay thế neofetch
  };
}