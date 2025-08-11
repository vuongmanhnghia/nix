# 🏔️ NixOS Hyprland Configuration

<div align="center">

[![NixOS](https://img.shields.io/badge/NixOS-25.05-blue.svg?style=flat&logo=nixos&logoColor=white)](https://nixos.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-Latest-blue.svg?style=flat&logo=wayland&logoColor=white)](https://hyprland.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](LICENSE)
[![Stars](https://img.shields.io/github/stars/nagih/nixos-config?style=flat)](https://github.com/vuongmanhnghia/nix)

_A modern, rice-focused NixOS configuration featuring Hyprland compositor with automatic color theming_

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Configuration](#%EF%B8%8F-configuration) • [Usage](#-usage)

⭐ Please **Star** the repository

</div>

<!-- ## 📋 Table of Contents

-   [🎯 Overview](#-overview)
-   [✨ Features](#-features)
-   [📸 Screenshots](#-screenshots)
-   [🏗️ System Architecture](#%EF%B8%8F-system-architecture)
-   [📦 Prerequisites](#-prerequisites)
-   [🚀 Installation](#-installation)
-   [⚙️ Configuration](#%EF%B8%8F-configuration)
-   [🎨 Theming](#-theming)
-   [🔧 Usage](#-usage)
-   [📁 Project Structure](#-project-structure)
-   [🤝 Contributing](#-contributing)
-   [📄 License](#-license)

--- -->

## Overview

This is a comprehensive NixOS configuration built around the **Hyprland** wayland compositor, designed for developers and enthusiasts who want a beautiful, functional, and reproducible desktop environment. The configuration emphasizes:

-   **Dynamic theming** with automatic color generation from wallpapers
-   **Performance** optimized for development workflows
-   **Modularity** with clean, organized code structure
-   **Beautiful aesthetics** with modern UI components
-   **Developer experience** with pre-configured tools and workflows

## Features

<details>
<summary>Click to expand detailed features</summary>

### 🖥️ **Desktop Environment**

-   **Hyprland** - Modern wayland compositor with smooth animations
-   **Waybar** - Highly customizable status bar with system monitoring
-   **Rofi** - Application launcher and window switcher
-   **SwayNC** - Notification center with custom styling
-   **Wlogout** - Beautiful logout menu

### 🎨 **Dynamic Theming System**

-   **Matugen** - Automatic color palette generation from wallpapers
-   **Live color updates** across all applications
-   **40+ wallpapers** included in the collection
-   **Auto wallpaper rotation** with configurable intervals
-   **Consistent theming** for GTK, Qt, and terminal applications

### 🔧 **Development Environment**

-   **Pre-configured IDEs**: Neovim, VS Code, Cursor
-   **Multiple languages**: Python, Go, JavaScript/Node.js, C/C++
-   **Docker & containerization** support
-   **Git with Delta** for enhanced diff viewing
-   **Modern CLI tools**: ripgrep, fd, bat, eza, fzf
-   **Terminal multiplexing** with tmux

### 📱 **Applications & Tools**

-   **Browsers**: Firefox with optimizations
-   **Media**: VLC, OBS Studio for streaming
-   **Productivity**: LibreOffice, Obsidian
-   **Gaming**: Steam with Proton support
-   **Communication**: Discord, Zoom
-   **Vietnamese input**: fcitx5 with unikey

### 🔒 **System Features**

-   **NVIDIA drivers** with Wayland support
-   **Audio system**: PipeWire with low-latency configuration
-   **Security**: Firewall, SSH hardening, PolicyKit
-   **Network**: NetworkManager, Tailscale VPN
-   **File sync**: Syncthing for cross-device synchronization
-   **Automatic cleanup** and garbage collection

<!-- ## 📸 Screenshots

<details>
<summary>🖼️ Click to view screenshots</summary>

> **Note**: Screenshots will be added soon! The desktop features a beautiful dark theme with dynamic colors that change based on the current wallpaper. -->

### Desktop Overview

-   Clean Hyprland desktop with Waybar
-   Dynamic color theming in action
-   Application launcher (Rofi)

### Development Environment

-   Neovim with LSP configuration
-   Terminal setup with modern tools
-   Multi-monitor workspace setup

### Media & Entertainment

-   Music visualization with Cava
-   Gaming setup with Steam
-   Media consumption setup

</details>

## Getting started

### Prerequisites

-   **NixOS 25.05** or later
-   **UEFI system** with secure boot support
-   **NVIDIA GPU** (optional, but configurations are optimized for it)
-   **Internet connection** for flake inputs and package downloads
-   **At least 8GB RAM** recommended
-   **20GB+ free disk space** for system and packages

### Getting nix config

Clone the repository

```bash
git clone git@github.com:vuongmanhnghia/nix.git ~/Workspaces/Config/nixos
cd ~/Workspaces/Config/nixos
```

Backup your current configuration

```bash
sudo cp /etc/nixos/hardware-configuration.nix .
```

Setup your environment

```bash
bash setup.sh
```

Apply the configuration

```bash
sudo nixos-rebuild switch --flake .#nixos
```

Apply user configuration

```bash
home-manager switch --flake .#your-username
```

### First Boot Setup

After successful installation: Update the system

```bash
sudo nixos-rebuild switch --flake ~/Workspaces/Config/nixos --upgrade
```

Enable and start essential services

```bash
systemctl --user start swww-daemon
```

Set initial wallpaper

```bash
cd ~/Workspaces/Config/nixos
./home/shared/matugen/scripts/wppicker.sh
```

## Configuration

### **Customizing for Your System**

1. **Update User Information**:

    ```nix
    # home/nagih.nix
    home.username = "your-username";
    home.homeDirectory = "/home/your-username";

    # Git configuration
    programs.git = {
      userName = "Your Name";
      userEmail = "your.email@example.com";
    };
    ```

2. **Hardware Configuration**:

    ```bash
    # Generate new hardware config for your system
    sudo nixos-generate-config
    cp /etc/nixos/hardware-configuration.nix .
    ```

3. **NVIDIA Configuration** (if not using NVIDIA):
    ```nix
    # desktop/graphics.nix
    # Comment out NVIDIA-specific configurations
    # services.xserver.videoDrivers = ["amdgpu"]; # For AMD
    ```

### **Network Configuration**

```nix
# system/networking.nix
networking = {
  hostName = "your-hostname";  # Change this
  # Configure wireless if needed
  # wireless.enable = true;
};
```

### **Security Settings**

```nix
# system/security.nix
services.openssh.settings = {
  PasswordAuthentication = false;  # Key-only SSH
  PermitRootLogin = "no";         # Disable root login
};
```

## Theming

### **Dynamic Color System**

The configuration uses **Matugen** to generate colors from wallpapers:

```bash
# Manual wallpaper change with color generation
matugen image /path/to/wallpaper.jpg

# Pick wallpaper with GUI
~/Workspaces/Config/nixos/home/shared/matugen/scripts/wppicker.sh

# Enable automatic wallpaper rotation (every 5 minutes)
systemctl --user enable --now auto-wallpaper.timer
```

### **Adding Wallpapers**

```bash
# Add wallpapers to the collection
cp your-wallpaper.jpg ~/Workspaces/Config/nixos/wallpapers/

# Supported formats: .jpg, .jpeg, .png, .gif
```

## Usage

### **Quick Commands**

```bash
# System management
nix-rebuild          # Rebuild and switch system configuration
home-rebuild         # Rebuild user configuration
nix-clean           # Clean old generations and optimize store
generations         # List system generations

# Wallpaper management
auto-wp-start       # Start automatic wallpaper rotation
auto-wp-stop        # Stop automatic wallpaper rotation
auto-wp-now         # Change wallpaper immediately

# Development workflow
wsp                 # Go to workspace directory
config              # Go to config directory
tm                  # Start tmux
```

### **Key Bindings**

| Shortcut              | Action                      |
| --------------------- | --------------------------- |
| `Super + Return`      | Open terminal (Kitty)       |
| `Super + D`           | Application launcher (Rofi) |
| `Super + Q`           | Close window                |
| `Super + F`           | Toggle fullscreen           |
| `Super + Space`       | Toggle floating             |
| `Super + 1-9`         | Switch workspace            |
| `Super + Shift + 1-9` | Move window to workspace    |
| `Super + L`           | Lock screen                 |
| `Super + Shift + E`   | Logout menu                 |
| `Print`               | Screenshot                  |

### **Development Tools**

Pre-configured development environment includes:

```bash
# Languages & Runtimes
- Python 3 with pip, poetry, jupyter
- Node.js with npm, yarn, pnpm
- Go with gopls, delve debugger
- C/C++ with gcc, clang, cmake

# Editors & IDEs
- Neovim with LSP, treesitter, plugins
- VS Code with extensions
- Cursor AI-powered editor

# CLI Tools
- ripgrep (rg) - Fast text search
- fd - Modern find replacement
- bat - Syntax highlighted cat
- eza - Modern ls replacement
- fzf - Fuzzy finder
- delta - Enhanced git diff
```

---

<div align="center">

**Made with Nagih for the NixOS community**

_Reproducible • Beautiful • Functional_

</div>
