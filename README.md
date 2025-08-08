# 🏔️ NixOS Hyprland Configuration

<div align="center">

[![NixOS](https://img.shields.io/badge/NixOS-25.05-blue.svg?style=flat&logo=nixos&logoColor=white)](https://nixos.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-Latest-blue.svg?style=flat&logo=wayland&logoColor=white)](https://hyprland.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](LICENSE)
[![Stars](https://img.shields.io/github/stars/nagih/nixos-config?style=flat)](https://github.com/nagih/nixos-config)

_A modern, rice-focused NixOS configuration featuring Hyprland compositor with automatic color theming_

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Configuration](#%EF%B8%8F-configuration) • [Usage](#-usage)

</div>

---

## 📋 Table of Contents

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

---

## 🎯 Overview

This is a comprehensive NixOS configuration built around the **Hyprland** wayland compositor, designed for developers and enthusiasts who want a beautiful, functional, and reproducible desktop environment. The configuration emphasizes:

-   **🎨 Dynamic theming** with automatic color generation from wallpapers
-   **⚡ Performance** optimized for development workflows
-   **🔧 Modularity** with clean, organized code structure
-   **🌈 Beautiful aesthetics** with modern UI components
-   **🚀 Developer experience** with pre-configured tools and workflows

---

## ✨ Features

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

---

## 📸 Screenshots

<details>
<summary>🖼️ Click to view screenshots</summary>

> **Note**: Screenshots will be added soon! The desktop features a beautiful dark theme with dynamic colors that change based on the current wallpaper.

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

---

## 🏗️ System Architecture

```
📁 NixOS Configuration
├── 🔧 System Level (NixOS)
│   ├── Boot & Kernel Configuration
│   ├── Hardware Support (NVIDIA, Audio)
│   ├── Network & Security
│   └── System Packages
├── 🏠 User Level (Home Manager)
│   ├── Desktop Environment (Hyprland)
│   ├── Applications & Tools
│   ├── Dotfiles & Configurations
│   └── Theming System
└── 🎨 Dynamic Theming
    ├── Wallpaper Collection
    ├── Color Generation (Matugen)
    └── Application Theme Updates
```

---

## 📦 Prerequisites

-   **NixOS 25.05** or later
-   **UEFI system** with secure boot support
-   **NVIDIA GPU** (optional, but configurations are optimized for it)
-   **Internet connection** for flake inputs and package downloads
-   **At least 8GB RAM** recommended
-   **20GB+ free disk space** for system and packages

---

## 🚀 Installation

### 1️⃣ **Fresh NixOS Installation**

If you're installing NixOS from scratch:

```bash
# Boot from NixOS ISO
# Partition your drives and mount them
# Generate hardware configuration
nixos-generate-config --root /mnt

# Clone this configuration
cd /mnt/home
git clone https://github.com/your-username/nixos-config.git
cd nixos-config

# Copy hardware configuration
cp /mnt/etc/nixos/hardware-configuration.nix .

# Install with flakes
nixos-install --flake .#nixos
```

### 2️⃣ **Existing NixOS System**

```bash
# Clone the repository
git clone https://github.com/your-username/nixos-config.git ~/Workspaces/Config/nixos
cd ~/Workspaces/Config/nixos

# Backup your current configuration
sudo cp /etc/nixos/hardware-configuration.nix .

# Apply the configuration
sudo nixos-rebuild switch --flake .#nixos

# Apply user configuration
home-manager switch --flake .#nagih
```

### 3️⃣ **First Boot Setup**

After successful installation:

```bash
# Update the system
sudo nixos-rebuild switch --flake ~/Workspaces/Config/nixos --upgrade

# Enable and start essential services
systemctl --user enable --now auto-wallpaper.timer
systemctl --user start swww-daemon

# Set initial wallpaper
cd ~/Workspaces/Config/nixos
./home/shared/matugen/scripts/wppicker.sh
```

---

## ⚙️ Configuration

### 🎯 **Customizing for Your System**

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

### 🌐 **Network Configuration**

```nix
# system/networking.nix
networking = {
  hostName = "your-hostname";  # Change this
  # Configure wireless if needed
  # wireless.enable = true;
};
```

### 🔐 **Security Settings**

```nix
# system/security.nix
services.openssh.settings = {
  PasswordAuthentication = false;  # Key-only SSH
  PermitRootLogin = "no";         # Disable root login
};
```

---

## 🎨 Theming

### 🌈 **Dynamic Color System**

The configuration uses **Matugen** to generate colors from wallpapers:

```bash
# Manual wallpaper change with color generation
matugen image /path/to/wallpaper.jpg

# Pick wallpaper with GUI
~/Workspaces/Config/nixos/home/shared/matugen/scripts/wppicker.sh

# Enable automatic wallpaper rotation (every 5 minutes)
systemctl --user enable --now auto-wallpaper.timer
```

### 🎨 **Supported Applications**

Colors are automatically applied to:

-   **Waybar** - Status bar
-   **Kitty** - Terminal
-   **Rofi** - Application launcher
-   **SwayNC** - Notification center
-   **GTK** applications
-   **Hyprland** - Window borders
-   **Cava** - Audio visualizer

### 🖼️ **Adding Wallpapers**

```bash
# Add wallpapers to the collection
cp your-wallpaper.jpg ~/Workspaces/Config/nixos/wallpapers/

# Supported formats: .jpg, .jpeg, .png, .gif
```

---

## 🔧 Usage

### 🚀 **Quick Commands**

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

### ⌨️ **Key Bindings**

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

### 🔧 **Development Tools**

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

## 📁 Project Structure

<details>
<summary>🗂️ Click to expand detailed structure</summary>

```
📦 nixos/
├── 📄 flake.nix                 # Main flake configuration
├── 📄 configuration.nix         # System configuration entry point
├── 📄 hardware-configuration.nix # Hardware-specific settings
├── 📄 current_wallpaper         # Current wallpaper symlink
├── 📄 README.md                 # This file
│
├── 📁 system/                   # System-level configurations
│   ├── 📄 default.nix          # System modules entry point
│   ├── 📄 boot.nix             # Bootloader & kernel config
│   ├── 📄 users.nix            # User accounts & groups
│   ├── 📄 networking.nix       # Network & firewall settings
│   ├── 📄 locale.nix           # Timezone & locale settings
│   ├── 📄 packages.nix         # Essential system packages
│   └── 📄 security.nix         # Security policies
│
├── 📁 desktop/                  # Desktop environment
│   ├── 📄 default.nix          # Desktop modules entry
│   ├── 📄 hyprland.nix         # Hyprland system config
│   ├── 📄 audio.nix            # PipeWire audio system
│   ├── 📄 graphics.nix         # NVIDIA & graphics drivers
│   └── 📄 fonts.nix            # System fonts
│
├── 📁 programs/                 # Application configurations
│   ├── 📄 default.nix          # Programs modules entry
│   ├── 📄 development.nix      # Development tools & IDEs
│   ├── 📄 python.nix           # Python development environment
│   ├── 📄 golang.nix           # Go development environment
│   ├── 📄 gaming.nix           # Gaming platform (Steam)
│   ├── 📄 multimedia.nix       # Media apps & Vietnamese input
│   └── 📄 entries.nix          # Desktop entries
│
├── 📁 home/                     # User configurations (Home Manager)
│   ├── 📄 default.nix          # Shared user configuration
│   ├── 📄 nagih.nix            # User-specific config
│   │
│   └── 📁 shared/              # Shared user configurations
│       ├── 📄 git.nix          # Git configuration
│       ├── 📄 zsh.nix          # Zsh shell with aliases
│       ├── 📄 neovim.nix       # Neovim editor config
│       ├── 📄 kitty.nix        # Kitty terminal config
│       ├── 📄 gtk-theme.nix    # GTK theme settings
│       ├── 📄 fastfetch.nix    # System info tool
│       └── 📄 ripgrep.nix      # Text search tool config
│       │
│       ├── 📁 hypr/            # Hyprland configurations
│       │   ├── 📄 default.nix  # Main Hyprland config
│       │   ├── 📁 modules/     # Hyprland feature modules
│       │   │   ├── 📄 animation.nix    # Animations
│       │   │   ├── 📄 appearance.nix   # Window appearance
│       │   │   ├── 📄 autostart.nix    # Startup applications
│       │   │   ├── 📄 environment.nix  # Environment variables
│       │   │   ├── 📄 input.nix        # Input devices
│       │   │   ├── 📄 keybinding.nix   # Key bindings
│       │   │   ├── 📄 layout.nix       # Window layouts
│       │   │   ├── 📄 misc.nix         # Miscellaneous settings
│       │   │   ├── 📄 monitors.nix     # Monitor configuration
│       │   │   ├── 📄 programs.nix     # Default applications
│       │   │   ├── 📄 tags.nix         # Workspace tags
│       │   │   ├── 📄 windowrule.nix   # Window rules
│       │   │   ├── 📄 workspaces.nix   # Workspace settings
│       │   │   └── 📄 colors.nix       # Color configuration
│       │   │
│       │   └── 📁 scripts/     # Utility scripts
│       │       ├── 📄 brightness.sh    # Brightness control
│       │       ├── 📄 screenshot.sh    # Screenshot utility
│       │       └── 📄 volume.sh        # Volume control
│       │
│       ├── 📁 waybar/          # Status bar configuration
│       │   ├── 📄 default.nix  # Main waybar config
│       │   ├── 📄 settings.nix # Bar layout & modules
│       │   ├── 📄 styles.nix   # CSS styling
│       │   │
│       │   └── 📁 modules/     # Waybar modules
│       │       ├── 📄 default.nix      # Modules entry point
│       │       ├── 📄 system.nix       # System info modules
│       │       ├── 📄 hyprland.nix     # Hyprland integration
│       │       ├── 📄 audio.nix        # Audio modules
│       │       ├── 📄 network.nix      # Network modules
│       │       ├── 📄 media.nix        # Media player modules
│       │       ├── 📄 custom.nix       # Custom modules
│       │       ├── 📄 separators.nix   # Visual separators
│       │       ├── 📄 groups.nix       # Module groups
│       │       └── 📄 other.nix        # Other modules
│       │
│       ├── 📁 rofi/            # Application launcher
│       │   ├── 📄 default.nix  # Main rofi config
│       │   └── 📄 colors.nix   # Color configuration
│       │
│       ├── 📁 swaync/          # Notification center
│       │   └── 📄 default.nix  # SwayNC configuration
│       │
│       ├── 📁 wlogout/         # Logout menu
│       │   └── 📄 default.nix  # Wlogout configuration
│       │
│       └── 📁 matugen/         # Dynamic theming system
│           ├── 📄 default.nix  # Main matugen config
│           │
│           ├── 📁 modules/     # Matugen modules
│           │   ├── 📄 config.nix       # Main configuration
│           │   ├── 📄 aliases.nix      # Shell aliases
│           │   ├── 📄 service.nix      # Systemd service
│           │   └── 📄 auto-wallpaper.nix # Auto rotation
│           │
│           ├── 📁 scripts/     # Matugen scripts
│           │   ├── 📄 matugen-apply.sh # Apply colors script
│           │   ├── 📄 set-wallpaper.sh # Wallpaper setter
│           │   ├── 📄 auto-wallpaper.sh # Auto rotation
│           │   ├── 📄 wppicker.sh      # Wallpaper picker GUI
│           │   └── 📄 reload-apps.sh   # Reload applications
│           │
│           └── 📁 templates/   # Color templates
│               ├── 📄 colors.css       # CSS template
│               ├── 📄 kitty.conf       # Kitty template
│               ├── 📄 hyprland.conf    # Hyprland template
│               ├── 📄 gtk.css          # GTK template
│               ├── 📄 rofi.rasi        # Rofi template
│               └── 📄 cava             # Cava template
│
├── 📁 colors/                  # Generated color files (git-ignored)
│   ├── 📄 waybar.css          # Waybar colors
│   ├── 📄 kitty.conf          # Kitty colors
│   ├── 📄 hypr.conf           # Hyprland colors
│   ├── 📄 gtk.css             # GTK colors
│   ├── 📄 rofi.rasi           # Rofi colors
│   ├── 📄 swaync.css          # SwayNC colors
│   └── 📄 cava.config         # Cava colors
│
├── 📁 wallpapers/             # Wallpaper collection
│   ├── 🖼️ anime-wallpaper-1.jpg
│   ├── 🖼️ landscape-1.png
│   ├── 🖼️ abstract-1.gif
│   └── 🖼️ ... (40+ wallpapers)
│
└── 📁 dotfiles/               # Application dotfiles
    ├── 📁 nvim/               # Neovim configuration
    │   ├── 📄 init.lua        # Main config
    │   ├── 📄 lazy-lock.json  # Plugin lockfile
    │   ├── 📁 lua/            # Lua modules
    │   └── 📁 ftplugin/       # Filetype plugins
    │
    ├── 📁 tmux/               # Tmux configuration
    │   ├── 📄 tmux.conf       # Main config
    │   └── 📄 random_note.sh  # Utility script
    │
    └── 📁 zsh/                # Zsh configuration
        └── 📄 p10k.zsh        # Powerlevel10k theme
```

</details>

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### 🐛 **Bug Reports**

-   Open an issue with detailed reproduction steps
-   Include system information and error logs
-   Test on a clean NixOS installation if possible

### 💡 **Feature Requests**

-   Describe the feature and its benefits
-   Provide use cases and examples
-   Consider implementation complexity

### 🔧 **Pull Requests**

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes following the existing code style
4. Test thoroughly on your system
5. Update documentation if needed
6. Submit a pull request with clear description

### 📝 **Documentation**

-   Fix typos and improve clarity
-   Add examples and use cases
-   Update outdated information
-   Translate to other languages

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

-   **NixOS Community** - For the amazing package manager and OS
-   **Hyprland Team** - For the beautiful wayland compositor
-   **Matugen** - For dynamic color generation capabilities
-   **JaKooLit** - For Hyprland configuration inspiration
-   **Catppuccin** - For the beautiful color palette
-   **All Contributors** - For improvements and bug fixes

---

## 📞 Support

If you find this configuration helpful, please:

-   ⭐ **Star** the repository
-   🐛 **Report issues** you encounter
-   💡 **Suggest improvements**
-   🤝 **Contribute** to the project

For questions and support:

-   Open an issue on GitHub
-   Join NixOS community forums
-   Check the NixOS documentation

---

<div align="center">

**Made with ❤️ for the NixOS community**

_Reproducible • Beautiful • Functional_

</div>
