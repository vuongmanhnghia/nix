{ config, pkgs, unstable, ... }:

{
  # === MINIMAL AUDIO CONFIGURATION - NixOS 25.11 Default ===
  
  # PipeWire với WirePlumber từ unstable (bỏ qua state-routes bug)
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
    
    # Config WirePlumber để tắt state-routes script (chứa bug)
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-disable-routes.conf" ''
        wireplumber.profiles = {
          main = {
            # Disable state-routes.lua - có bug
            state-routes.lua = disabled
          }
        }
      '')
    ];
  };


  # RealtimeKit for low-latency audio
  security.rtkit.enable = true;

  # SOF Firmware for modern Intel/AMD audio
  hardware.firmware = [ pkgs.sof-firmware ];

  # Basic audio utilities
  environment.systemPackages = with pkgs; [
    pavucontrol  # PulseAudio Volume Control GUI
    alsa-utils   # ALSA utilities
    sof-firmware
  ];
} 