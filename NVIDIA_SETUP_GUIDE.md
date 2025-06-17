# NVIDIA Setup Guide for NixOS 25.05 (Flakes + Home-Manager)

## Overview

Cấu hình tối ưu cho card đồ họa NVIDIA trên NixOS 25.05 với hỗ trợ:

-  **Desktop**: RTX 4060
-  **Laptop**: RTX 3050 Ti (dual GPU với Intel)
-  **Features**: Wayland, X11, Gaming, Hardware Acceleration, Power Management

## Architecture

```
flake.nix
├── modules/
│   ├── desktop/
│   │   ├── nvidia.nix      # Cấu hình NVIDIA chính
│   │   ├── xserver.nix     # X11 + Display settings
│   │   └── default.nix     # Import modules
│   └── system/
└── scripts/
    └── nvidia-bus-id-check.sh  # Kiểm tra Bus ID
```

## Key Features

### 1. **Auto-Detection**

-  Tự động phát hiện Desktop vs Laptop
-  Tự động chọn driver phù hợp (open vs proprietary)
-  Tự động cấu hình PRIME cho laptop

### 2. **Performance Optimization**

-  Gaming optimizations (GameMode, low-latency audio)
-  Custom refresh rates (180Hz desktop, 144Hz laptop)
-  Hardware acceleration (VAAPI, Vulkan, OpenCL)
-  Shader caching

### 3. **Power Management**

-  Fine-grained power management cho laptop
-  Suspend/resume support
-  Dynamic performance modes

### 4. **Dual Boot Support**

-  Specialisations cho gaming vs power-saving
-  Runtime switching capability

## Setup Instructions

### Step 1: Backup Current Configuration

```bash
sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup
```

### Step 2: Apply New Configuration

```bash
# Rebuild with new NVIDIA configuration
sudo nixos-rebuild switch --flake .

# For laptop users, switch to specific specialisation
sudo nixos-rebuild switch --flake . --specialisation gaming
# hoặc
sudo nixos-rebuild switch --flake . --specialisation powersave
```

### Step 3: Verify Installation

```bash
# Check GPU detection
nvidia-smi

# Check OpenGL
glxinfo | grep -i vendor

# Check Vulkan
vulkaninfo | grep -i device

# Check PRIME status (laptop only)
cat /sys/kernel/debug/vgaswitcheroo/switch

# Run bus ID detection script
chmod +x scripts/nvidia-bus-id-check.sh
./scripts/nvidia-bus-id-check.sh
```

## Configuration Details

### RTX 4060 (Desktop) Optimizations

-  Open-source kernel modules (`open = true`)
-  Maximum performance mode
-  180Hz custom refresh rate support
-  No power management constraints

### RTX 3050 Ti (Laptop) Optimizations

-  Proprietary drivers for stability (`open = false`)
-  PRIME sync/offload support
-  Fine-grained power management
-  Suspend/resume optimization
-  Battery-friendly settings

### Wayland Support

```nix
environment.sessionVariables = {
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  LIBVA_DRIVER_NAME = "nvidia";
  __GL_VRR_ALLOWED = "1";
  WLR_NO_HARDWARE_CURSORS = "1";
};
```

### Gaming Optimizations

```nix
environment.sessionVariables = {
  __GL_THREADED_OPTIMIZATIONS = "1";
  __GL_SHADER_DISK_CACHE = "1";
  __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
  __GL_MaxFramesAllowed = "1";
};
```

## Troubleshooting

### Common Issues

#### 1. **Wrong Bus ID (Laptop)**

```bash
# Run the detection script
./scripts/nvidia-bus-id-check.sh

# Update nvidia.nix with correct Bus IDs
hardware.nvidia.prime = {
  intelBusId = "PCI:0:2:0";    # Update này
  nvidiaBusId = "PCI:1:0:0";   # Update này
};
```

#### 2. **Black Screen After Boot**

```bash
# Add to kernel parameters in configuration.nix
boot.kernelParams = [
  "nvidia.modeset=1"
  "nvidia-drm.modeset=1"
];
```

#### 3. **Poor Performance in Games**

```bash
# Switch to gaming specialisation
sudo nixos-rebuild switch --flake . --specialisation gaming

# Verify GPU is being used
nvidia-smi
glxinfo | grep -i nvidia
```

#### 4. **High Power Consumption (Laptop)**

```bash
# Switch to power-saving mode
sudo nixos-rebuild switch --flake . --specialisation powersave

# Check power state
cat /sys/class/drm/card1/device/power_state
```

#### 5. **Wayland Issues**

```bash
# Force X11 if needed (add to environment variables)
GDK_BACKEND=x11
QT_QPA_PLATFORM=xcb

# Or disable Wayland in xserver.nix
displayManager.gdm.wayland = false;
```

### Monitoring Commands

```bash
# GPU utilization
nvtop

# Detailed GPU info
nvidia-smi -q

# VRAM usage
nvidia-smi --query-gpu=memory.used,memory.total --format=csv

# Temperature monitoring
watch -n 1 nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits

# Check PRIME offload status (laptop)
__NV_PRIME_RENDER_OFFLOAD=1 glxinfo | grep -i vendor
```

## Performance Tuning

### For Gaming (Desktop RTX 4060)

```bash
# Maximum performance mode
nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1'

# Enable resizable BAR if supported
# Add to kernel parameters: pci=realloc

# Optimize CPU governor
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

### For Development (Both)

```bash
# CUDA development
nix-shell -p cudatoolkit

# Container support
docker run --gpus all nvidia/cuda:11.0-base nvidia-smi
```

### For Video Encoding/Streaming

```bash
# Check NVENC support
ffmpeg -hide_banner -encoders | grep nvenc

# OBS Studio with NVENC
# Add to home.nix or environment.systemPackages:
# obs-studio with NVENC support is included
```

## Advanced Configuration

### Multi-Monitor Setup (Desktop)

```nix
services.xserver.displayManager.sessionCommands = ''
  # Dual monitor example
  ${pkgs.xorg.xrandr}/bin/xrandr \
    --output DP-1 --mode "2560x1440" --rate 180 --primary \
    --output HDMI-1 --mode "1920x1080" --rate 60 --right-of DP-1
'';
```

### Custom Fan Curves

```bash
# Enable coolbits for fan control
nvidia-settings -a '[gpu:0]/GPUFanControlState=1'
nvidia-settings -a '[fan:0]/GPUTargetFanSpeed=75'
```

### Development Environment

```nix
# Add to home.nix for development
home.packages = with pkgs; [
  cudatoolkit
  nvidia-docker
  blender # CUDA acceleration
  davinci-resolve # Video editing with GPU
];
```

## Security Considerations

```nix
# Restrict access to GPU
users.groups.gpu = {};
services.udev.extraRules = ''
  SUBSYSTEM=="drm", KERNEL=="card*", GROUP="gpu", MODE="0660"
  SUBSYSTEM=="nvidia*", GROUP="gpu", MODE="0660"
'';

# Add user to gpu group
users.users.youruser.extraGroups = [ "gpu" ];
```

## Migration from Old Config

If migrating from an existing NVIDIA setup:

1. **Backup current xserver.nix**
2. **Remove old NVIDIA configurations from xserver.nix**
3. **Apply new nvidia.nix module**
4. **Run bus ID detection script**
5. **Test with Wayland and X11**

## Support

For issues:

1. Run `./scripts/nvidia-bus-id-check.sh`
2. Check `journalctl -b | grep nvidia`
3. Verify `lsmod | grep nvidia`
4. Test `glxinfo | grep -i nvidia`

## References

-  [NixOS NVIDIA Wiki](https://nixos.wiki/wiki/Nvidia)
-  [NVIDIA Driver Archive](https://www.nvidia.com/drivers/)
-  [PRIME Documentation](https://wiki.archlinux.org/title/PRIME)
