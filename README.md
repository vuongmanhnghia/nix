# NixOS Hyprland Configuration

A modern NixOS configuration featuring the Hyprland compositor with automatic color theming.

## Overview

This is a comprehensive NixOS configuration built around the Hyprland wayland compositor, designed for developers and enthusiasts who want a beautiful, functional, and reproducible desktop environment. The configuration emphasizes dynamic theming, performance optimization, modularity, and developer experience.

## Installation

### Prerequisites

- NixOS 25.11 or later
- UEFI system
- Internet connection
- At least 8GB RAM recommended
- 20GB+ free disk space

### Setup

1. Clone the repository:

    ```bash
    git clone git@github.com:vuongmanhnghia/nix.git
    ```

    or

    ```bash
    git clone https://github.com/vuongmanhnghia/nix.git
    ```

2. Run setup script:

    ```bash
    ./setup.sh
    ```

3. Follow script instruction

## Configuration

## Theming

The configuration uses Matugen for dynamic colors:

```bash
matugen image /path/to/wallpaper.jpg
```

## Usage

### Key Bindings

- `Super + Space`: Open terminal
- `Super + B`: Browser
- `Super + E`: File explorer
- `Super + F`: Toggle fullscreen
- `Super + 1-9`: Switch workspace
- `Super + Shift + 1-9`: Move window to workspace
- `Super + Shift + L`: Lock screen

### Development Tools

Pre-configured environment includes:

- Python with pip, poetry, jupyter
- Node.js with npm, yarn, pnpm
- Go with gopls, delve
- C/C++ with gcc, clang, cmake
- Neovim with LSP and plugins
- VS Code and Cursor editors
- CLI tools: ripgrep, fd, bat, eza, fzf, delta

## Quickshell
