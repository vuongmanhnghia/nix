{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    rustdesk
    # === CODE EDITORS ===
    neovim                    # Modern Vim-based text editor with LSP support   
    # === LUA DEVELOPMENT ===
    lua51Packages.lua         # Modern Lua interpreter (latest version)
    luarocks                  # Replaced by rocks.nvim for better Neovim integration 

    # === TERMINAL MULTIPLEXER AND UTILITIES ===
    tmux                      # Terminal multiplexer for managing multiple terminal sessions
    ngrok                     # Secure tunnels to localhost  
    
    # === SYNTAX HIGHLIGHTING AND CODE TOOLS ===
    highlight                 # Universal syntax highlighter
    glow                      # Markdown renderer for terminal
    delta                     # Better git diff with syntax highlighting
    zsh-syntax-highlighting   # Syntax highlighting for zsh commands

    # === WEB DEVELOPMENT AND API TOOLS ===
    burpsuite                 # Web application security testing tool 
    postman                   # API development tool
    bruno                     # API client for testing RESTful APIs 
    pm2                       # Process manager for Node.js
    nodePackages.vercel       # Vercel CLI
    dbeaver-bin               # Database management tool

    # === TOOLS ===
    hugo                       # Static site generator
    yt-dlp                     # YouTube downloader
    libopus                    # Audio codec library
    cloudflared     # Cloudflare Tunnel
    amazon-q-cli    # Amazon Q CLI
    qbittorrent     # Torrent client
    speedtest-cli   # Internet speed test command line interface

    rpi-imager                  # Raspberry Pi OS Imager
  ];

  # services.udev.packages = [ pkgs.opentabletdriver ]; # Tablet
}