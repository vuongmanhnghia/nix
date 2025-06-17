#!/usr/bin/env bash

# Script to check GPU Bus IDs for NVIDIA PRIME configuration
# Usage: ./nvidia-bus-id-check.sh

echo "=== NVIDIA GPU Bus ID Detection Script ==="
echo ""

# Check if running on a laptop or desktop
chassis_type=$(cat /sys/class/dmi/id/chassis_type 2>/dev/null || echo "1")
case $chassis_type in
    8|9|10|14)
        device_type="Laptop"
        ;;
    *)
        device_type="Desktop"
        ;;
esac

echo "Device Type: $device_type"
echo ""

# List all GPUs
echo "=== All Graphics Devices ==="
lspci | grep -E "(VGA|3D)"
echo ""

# Get specific bus IDs
echo "=== Bus ID Information ==="
intel_bus=$(lspci | grep -E "(VGA|3D)" | grep -i intel | cut -d' ' -f1 | head -1)
nvidia_bus=$(lspci | grep -E "(VGA|3D)" | grep -i nvidia | cut -d' ' -f1 | head -1)

if [ -n "$intel_bus" ]; then
    echo "Intel GPU Bus ID: PCI:$(echo $intel_bus | sed 's/:/ /g' | awk '{printf "%d:%d:%d", "0x"$1, "0x"$2, "0x"$3}')"
fi

if [ -n "$nvidia_bus" ]; then
    echo "NVIDIA GPU Bus ID: PCI:$(echo $nvidia_bus | sed 's/:/ /g' | awk '{printf "%d:%d:%d", "0x"$1, "0x"$2, "0x"$3}')"
fi

echo ""

# NVIDIA GPU Information
if [ -n "$nvidia_bus" ]; then
    echo "=== NVIDIA GPU Details ==="
    nvidia_info=$(lspci -v -s $nvidia_bus)
    echo "$nvidia_info"
    echo ""
    
    # Try to get GPU name
    gpu_name=$(echo "$nvidia_info" | grep -i "nvidia" | head -1 | cut -d':' -f3 | sed 's/^ *//')
    echo "GPU Model: $gpu_name"
    echo ""
fi

# Current NVIDIA driver status
echo "=== NVIDIA Driver Status ==="
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=name,driver_version,power.management --format=csv,noheader,nounits
else
    echo "nvidia-smi not available - NVIDIA drivers may not be installed"
fi
echo ""

# Prime status (if available)
if [ "$device_type" = "Laptop" ] && command -v prime-select &> /dev/null; then
    echo "=== PRIME Status ==="
    prime-select query
    echo ""
fi

# Recommended configuration
echo "=== Recommended NixOS Configuration ==="
echo ""
if [ "$device_type" = "Laptop" ] && [ -n "$intel_bus" ] && [ -n "$nvidia_bus" ]; then
    echo "For your laptop, add this to your nvidia.nix:"
    echo ""
    echo "hardware.nvidia.prime = {"
    echo "  sync.enable = true;  # or offload.enable = true for power saving"
    echo "  intelBusId = \"PCI:$(echo $intel_bus | sed 's/:/ /g' | awk '{printf "%d:%d:%d", "0x"$1, "0x"$2, "0x"$3}')\";"
    echo "  nvidiaBusId = \"PCI:$(echo $nvidia_bus | sed 's/:/ /g' | awk '{printf "%d:%d:%d", "0x"$1, "0x"$2, "0x"$3}')\";"
    echo "};"
elif [ "$device_type" = "Desktop" ] && [ -n "$nvidia_bus" ]; then
    echo "For your desktop, the current nvidia.nix configuration should work."
    echo "NVIDIA GPU detected at: PCI:$(echo $nvidia_bus | sed 's/:/ /g' | awk '{printf "%d:%d:%d", "0x"$1, "0x"$2, "0x"$3}')"
fi

echo ""
echo "=== Additional Commands ==="
echo "Check NVIDIA processes: nvidia-smi"
echo "Check OpenGL info: glxinfo | grep -i vendor"
echo "Check Vulkan support: vulkaninfo | grep -i device"
echo "Monitor GPU usage: nvtop" 