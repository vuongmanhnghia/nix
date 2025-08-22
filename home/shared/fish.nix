# 🐟 FISH SHELL CONFIGURATION
# Modern shell alternative to zsh/bash
{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    # Custom fish configuration
    interactiveShellInit = ''
      # Disable greeting message
      set fish_greeting
      
      # Initialize starship prompt
      starship init fish | source
      
      # Load QuickShell terminal sequences if available
      if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
          cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
      end
    '';
    
    # Shell aliases
    shellAliases = {
      pamcan = "pacman";
      ls = "eza --icons";
      clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
      q = "qs -c ii";
    };
    
    # Fish functions
    functions = {
      fish_prompt = {
        description = "Custom fish prompt";
        body = ''
          # This shows up as USER@HOST /home/user/ >, with the directory colored
          printf '%s@%s %s%s%s > ' $USER $hostname \
              (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
        '';
      };
    };
  };
} 