{ config, pkgs, ... }:
{
  # Audio configuration with PipeWire
  services.pulseaudio.enable = false;
  
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    
    # Optional: enable JACK support
    jack.enable = true;
    
    # Low latency configuration
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 32;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 32;
      };
    };
  };

  # Audio packages
  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudio
    alsa-utils
  ];
}
