{ config, pkgs, ... }:

{
  # === AUDIO SYSTEM CONFIGURATION ===

    # PipeWire with all modules
  services.pipewire = {
    enable = true;
    
    # Enable compatibility layers
    alsa = {
      enable = true;
      support32Bit = true;
    };
    
    pulse.enable = true;  # PulseAudio compatibility - QUAN TRỌNG!
    jack.enable = true;   # JACK compatibility
    
    # Wireplumber session manager
    wireplumber.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;        # Sample rate (48kHz standard)
        default.clock.quantum = 32;        # Buffer size (32 samples = ~0.67ms latency)
        default.clock.min-quantum = 32;    # Minimum buffer size
        default.clock.max-quantum = 32;    # Maximum buffer size
      };
    };
  };

  # Ensure services start properly
  systemd.user.services = {
    pipewire.wantedBy = [ "default.target" ];
    pipewire-pulse.wantedBy = [ "default.target" ];
    wireplumber.wantedBy = [ "default.target" ];
  };
  
  # services.pulseaudio.enable = false;
  
  # Enable RealtimeKit for low-latency audio processing
  security.rtkit.enable = true;

  # === AUDIO UTILITIES ===
  environment.systemPackages = with pkgs; [
    pavucontrol  # PulseAudio Volume Control GUI
    alsa-utils   # ALSA command-line utilities
    lsp-plugins  # LSP (Linux Studio Plugins) for EasyEffects
    calf         # Calf Studio Gear plugins for audio processing

    reaper       # Digital Audio Workstation (DAW)
    yabridge     # Run Windows VST plugins on Linux
    qjackctl     # JACK Audio Connection Kit GUI
  ];

  # === EASY EFFECTS CONFIGURATION ===
  # Enable EasyEffects to work properly with PipeWire
  programs.dconf.enable = true; # Required for EasyEffects to save presets
} 