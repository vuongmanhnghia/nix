{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    # libinput                  # Tablet
    # opentabletdriver          # Tablet
    # === CODE EDITORS AND IDEs ===
    neovim                    # Modern Vim-based text editor with LSP support   
    # === LUA DEVELOPMENT ===
    lua51Packages.lua         # Modern Lua interpreter (latest version)
    luarocks                  # Replaced by rocks.nvim for better Neovim integration 

    # === TERMINAL MULTIPLEXER AND UTILITIES ===
    tmux                      # Terminal multiplexer for managing multiple terminal sessions
    termius                   # SSH client
    
    # === SYNTAX HIGHLIGHTING AND CODE TOOLS ===
    highlight                 # Universal syntax highlighter
    glow                      # Markdown renderer for terminal
    delta                     # Better git diff with syntax highlighting
    zsh-syntax-highlighting   # Syntax highlighting for zsh commands

    # === WEB DEVELOPMENT AND API TOOLS ===
    burpsuite                 # Web application security testing tool 
    postman                   # API development tool

    pm2                       # Process manager for Node.js
    nodePackages.vercel       # Vercel CLI

    # === TOOLS ===
    hugo                       # Static site generator
    yt-dlp                     # YouTube downloader
    libopus                    # Audio codec library

    # === DOCUMENTATION GENERATION ===
    doxygen         # Documentation generator for multiple programming languages

    cloudflared     # Cloudflare Tunnel
    amazon-q-cli    # Amazon Q CLI
    qbittorrent     # Torrent client
    speedtest-cli   # Internet speed test command line interface
  ];

  # services.udev.packages = [ pkgs.opentabletdriver ]; # Tablet
}