{ config, pkgs, ... }:
{
  # === GRAPHICS HARDWARE SUPPORT ===
  hardware.graphics = {
    enable = true; # Enable graphics drivers
    enable32Bit = true; # Enable 32-bit graphics support (required for gaming/Steam)
    # Additional graphics packages for enhanced functionality
    extraPackages = with pkgs; [
      nvidia-vaapi-driver # VA-API driver for hardware video acceleration
      vulkan-loader # Vulkan graphics API loader
      vulkan-tools # Vulkan utilities
      vulkan-validation-layers # Vulkan debugging and validation
    ];
  };

  powerManagement = {
    enable = true;
    powertop.enable = true; # Tự động apply các tối ưu hóa
  };
  
  # === NVIDIA DRIVER CONFIGURATION ===
  services.xserver.videoDrivers = ["nvidia"]; # Use NVIDIA proprietary driver
  
  hardware.nvidia = {
    # Enable modesetting for Wayland support (required for GNOME Wayland)
    modesetting.enable = true;
    # Enable power management features
    powerManagement.enable = true;
    # Use latest stable NVIDIA driver for best performance and features
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    # Enable NVIDIA X Server Settings GUI tool
    nvidiaSettings = true;
    # Use proprietary driver (set to true for open-source kernel module)
    open = false; # Keep false for stability with most GPUs
  };
  
  # === POWER MANAGEMENT ===
  services.upower.enable = true;
  services.thermald.enable = true;
  
  services.power-profiles-daemon.enable = false; # Disable to avoid conflicts with auto-cpufreq
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
  
  # === KERNEL CONFIGURATION FOR NVIDIA ===
  # Load necessary kernel modules for NVIDIA functionality
  boot.kernelModules = [
    "nvidia" # Main NVIDIA driver module
    "nvidia_modeset" # Modesetting support for Wayland
    "nvidia_uvm" # Unified Virtual Memory support
    "nvidia_drm" # Direct Rendering Manager support
    "kvm-intel" # KVM Intel driver
    "kvm-amd" # KVM AMD driver
  ];
  
  # Blacklist open-source Nouveau driver to prevent conflicts
  boot.blacklistedKernelModules = [ 
    "nouveau"
    # "kvm-intel" # KVM Intel drivek
    # "kvm-amd" # KVM AMD driver
  ];
  
  # === KERNEL BOOT PARAMETERS ===
  boot.kernelParams = [
    "nvidia-drm.modeset=1" # Enable NVIDIA DRM modesetting for Wayland
    # Intel GPU power saving
    "i915.enable_rc6=1"
    "i915.enable_fbc=1"
    "i915.enable_psr=1"
  ];
  
  # === ADDITIONAL GRAPHICS TOOLS ===
  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit # NVIDIA container runtime for Docker
    libva-utils # VA-API utilities for testing video acceleration
    vulkan-tools # Vulkan utilities (vulkaninfo, vkcube)
    intel-gpu-tools # Intel GPU tools for debugging
    powertop # Power management tool

    p11-kit
  ];
}
