{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    
    # === SHELL AND TERMINAL CONFIGURATION ===
    shell = "${pkgs.zsh}/bin/zsh";
    # terminal = "tmux-256color";
    
    # === BASIC SETTINGS ===
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    
    # === PERFORMANCE OPTIMIZATIONS ===
    extraConfig = ''
      set -g default-terminal "tmux-256color"

      # === WEZTERM COMPATIBILITY ===
      # Enable RGB color support (essential for Wezterm themes)
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides ",wezterm:Tc"
      
      # Enable undercurl support for Wezterm
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      
      # === PERFORMANCE OPTIMIZATIONS ===
      set -g repeat-time 600
      set -g focus-events on
      set -g aggressive-resize on
      
      # === WINDOW MANAGEMENT ===
      # Re-number when closing windows
      set-option -g renumber-windows on
      
      # === KEY BINDINGS ===
      # Send prefix key
      bind-key C-a send-prefix
      
      # Splitting windows
      unbind %
      bind '\' split-window -h -c '#{pane_current_path}'
      bind '¥' split-window -h -c '#{pane_current_path}'
      unbind '"'
      bind - split-window -v -c '#{pane_current_path}'
      
      # Reload configuration
      unbind r
      bind r source-file ~/.config/home-manager/tmux.conf \; display-message "Config reloaded!"
      
      # Resize panes
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r h resize-pane -L 5
      bind -r l resize-pane -R 5
      bind -r m resize-pane -Z
      
      # New window with current path
      bind c new-window -c '#{pane_current_path}'
      
      # === COPY MODE (VIM STYLE) ===
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection
      unbind -T copy-mode-vi MouseDragEnd1Pane
      
      # === CUSTOM PRODUCTIVITY BINDINGS ===
      # Open note for billion $ idea
      bind -r e split-window -h "nvim ~/Documents/git/scratch/notes_$(date +'%Y%m%d%H').md"
      bind -r v split-window -h -c "#{pane_current_path}" "zsh -c 'nvim; exec zsh'"
      bind -r o split-window -h "nvim ~/Documents/git/scratch/todo_$(date +'%y%m%d').md"
      
      # === TOKYO NIGHT THEME (matching Wezterm) ===
      # Status bar configuration with Tokyo Night theme - using direct colors
      set -g status-interval 1
      set -g status-position bottom
      set -g status-justify left
      set -g status-style "fg=#c0caf5,bg=#1a1b26"
      
      # Left status
      set -g status-left-length 100
      set -g status-left "#[fg=#1a1b26,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#1a1b26,nobold]"
      
      # Window status
      set -g window-status-separator ""
      set -g window-status-format "#[fg=#a9b1d6,bg=#1a1b26] #I:#W "
      set -g window-status-current-format "#[fg=#1a1b26,bg=#bb9af7]#[fg=#1a1b26,bg=#bb9af7,bold] #I:#W #[fg=#bb9af7,bg=#1a1b26,nobold]"
      
      # Right status
      set -g status-right-length 150
      set -g status-right "#[fg=#545c7e,bg=#1a1b26]#[fg=#c0caf5,bg=#545c7e] %Y-%m-%d #[fg=#7aa2f7,bg=#545c7e]#[fg=#1a1b26,bg=#7aa2f7,bold] %H:%M:%S "
      
      # Pane borders
      set -g pane-border-style "fg=#292e42"
      set -g pane-active-border-style "fg=#7aa2f7"
      
      # Message style
      set -g message-style "fg=#c0caf5,bg=#292e42"
      set -g message-command-style "fg=#c0caf5,bg=#292e42"
      
      # Copy mode
      set -g mode-style "fg=#1a1b26,bg=#7aa2f7"
      
      # Clock
      set -g clock-mode-colour "#7aa2f7"
      
      # === SESSION MANAGEMENT ===
      # Manual session management bindings
      bind S command-prompt -p "Save session to:" "run-shell 'tmux list-sessions > %1'"
      bind R source-file ~/.config/home-manager/tmux.conf \; display-message "Config reloaded!"
      
      # Override default 'w' to show only sessions (1 level), not windows
      unbind w
      bind w choose-tree -Zs
      # Use 'W' to show both sessions and windows (2 levels) if needed
      bind W choose-tree -Zw
    '';
    
    # === PLUGINS ===
    plugins = with pkgs.tmuxPlugins; [
      # Session save/restore functionality
      resurrect
      # Optional: continuum for automatic saving
      # continuum
      # Optional: better mouse support
      # sensible
    ];
  };
}