# Nix(Hyprland) - Nagih

## 📁 Cấu trúc

```
nixos-config/
├── flake.nix                    # Core flake configuration
├── configuration.nix            # Main system config
├── hardware-configuration.nix   # Hardware-specific settings
├── rebuild.sh                   # Advanced rebuild script
│
├── system/                      # System-level configurations
│   ├── default.nix             # System imports
│   ├── boot.nix                # Boot configuration (systemd-boot)
│   ├── users.nix               # User management
│   ├── networking.nix          # Network
│   ├── locale.nix              # Timezone & language
│   ├── packages.nix            # Essential system packages
│   └── security.nix            # Security settings
│
├── desktop/                     # Desktop environment
│   ├── default.nix             # Desktop imports
│   ├── hyprland.nix            # Hyprland window manager
│   ├── audio.nix               # PipeWire audio (0.67ms latency)
│   ├── graphics.nix            # NVIDIA graphics (latest)
│   └── fonts.nix               # System fonts
│
├── programs/                    # Application configurations
│   ├── default.nix             # Program imports
│   ├── development.nix         # Dev tools & Docker
│   ├── python.nix              # Python development
│   ├── golang.nix              # Go development
│   ├── gaming.nix              # Gaming (Steam, GameMode)
│   ├── multimedia.nix          # Media apps & Vietnamese input
│   └── entries.nix             # Desktop entries
│
└── home/                        # Home Manager configurations
    ├── default.nix             # Common home config
    ├── nagih.nix               # User-specific config
    └── shared/                 # Shared configurations
        ├── hypr/               # Hyprland user config
        ├── waybar/             # Waybar status bar
        ├── swaync/             # Notification center
        ├── rofi/               # Application launcher
        ├── kitty.nix           # Terminal configuration
        ├── neovim.nix          # Neovim setup
        ├── zsh.nix             # Zsh shell configuration
        ├── git.nix             # Git configuration
        ├── fastfetch.nix       # System info display
        ├── ripgrep.nix         # Search tools
        ├── gtk-theme.nix       # GTK theming
        ├── matugen/            # Material theme generator
        └── wlogout/            # Logout screen
```

## 🚀 Sử dụng

### Rebuild System

```bash
# Sử dụng shell alias
nix-rebuild

# Hoặc lệnh thủ công
sudo nixos-rebuild switch --flake .
```

### Rebuild Home Manager

```bash
# Sử dụng shell alias
home-rebuild

# Hoặc lệnh thủ công
home-manager switch --flake .
```

### Quick Commands

```bash
nix-rebuild     # Apply configuration
nix-test        # Test configuration
generations     # History generations
nix-clean       # Clean Nix
nix-reset       # Reset all Nix and rebuild
```

## ✨ Tính năng

### System

-   ✅ **Hyprland Wayland** - Modern tiling window manager
-   ✅ **NVIDIA latest driver** - Stable và performance
-   ✅ **PipeWire audio** - Low latency (0.67ms)
-   ✅ **Tailscale VPN** - Mesh network integration
-   ✅ **Development tools** - Docker, Git, modern CLI tools
-   ✅ **Security hardened** - SSH key-only, firewall enabled

### Desktop Environment

-   ✅ **Hyprland** - Tiling window manager với animations
-   ✅ **Waybar** - Status bar với modules
-   ✅ **Rofi** - Application launcher
-   ✅ **SwayNC** - Notification center
-   ✅ **Kitty** - GPU-accelerated terminal
-   ✅ **Material theming** - Matugen theme generator

### Development

-   ✅ **Python ecosystem** - pytest, black, isort, mypy
-   ✅ **Go development** - gopls, delve, golangci-lint
-   ✅ **C++ tools** - gcc, clang, cmake, gdb
-   ✅ **Docker** - Containerization platform
-   ✅ **Modern CLI** - ripgrep, fd, bat, eza, fzf
-   ✅ **Neovim** - LSP và modern keybindings

### Gaming

-   ✅ **Steam** - Native Wayland support
-   ✅ **GameMode** - Performance optimization
-   ✅ **Wine/Proton** - Windows compatibility
-   ✅ **Controller support** - PS4/PS5, Xbox, Nintendo
-   ✅ **MangoHud** - Performance overlay

### Vietnamese Support

-   ✅ **Fcitx5-Unikey** - Vietnamese input method
-   ✅ **Vietnamese fonts** - Source Han Sans/Serif
-   ✅ **Locale settings** - Asia/Ho_Chi_Minh timezone

## 🔧 Customization

### Thêm System Packages

Edit `system/packages.nix`

### Thêm User Packages

Edit `home/nagih.nix` hoặc `home/default.nix`

### Hyprland Configuration

Edit `home/shared/hypr/` directory

### Development Environment

-   **Python**: Edit `programs/python.nix`
-   **Go**: Edit `programs/golang.nix`
-   **C++**: Edit `programs/development.nix`

## 🛡️ Security Features

-   Root login disabled
-   SSH key authentication only
-   Firewall enabled với ports cần thiết
-   Tailscale VPN integration
-   Automatic security updates

## 🆕 Adding New Users

1. Copy `home/nagih.nix` thành `home/username.nix`
2. Update user config
3. Add vào `flake.nix` home-manager users section
4. Add user vào `system/users.nix`

````

## 🎨 Theming

### Material Theme Generator

```bash
# Generate theme from wallpaper
matugen generate image wallpaper.jpg
````

### GTK/Qt Theming

-   Catppuccin theme integration
-   Papirus icon theme
-   WhiteSur cursors
-   Automatic dark/light mode

### System Monitoring

```bash
btop                # Modern system monitor
fastfetch           # System info display
neofetch            # ASCII art system info
```

---

Contact: vuongmanhnghia@gmail.com
