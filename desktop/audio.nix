{ config, pkgs, ... }:

{
  # === AUDIO SYSTEM CONFIGURATION ===
  
  # Disable legacy PulseAudio (replaced by PipeWire)
  services.pulseaudio.enable = false;
  
  # Enable RealtimeKit for low-latency audio processing
  security.rtkit.enable = true;

  # === PIPEWIRE AUDIO SERVER ===
  services.pipewire = {
    enable = true;              # Enable PipeWire audio server
    alsa.enable = true;         # ALSA compatibility layer
    alsa.support32Bit = true;   # 32-bit ALSA support for older applications
    pulse.enable = true;        # PulseAudio compatibility layer
    jack.enable = true;         # JACK compatibility for professional audio

    # === LOW-LATENCY CONFIGURATION ===
    # Optimized settings for minimal audio latency
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;        # Sample rate (48kHz standard)
        default.clock.quantum = 32;        # Buffer size (32 samples = ~0.67ms latency)
        default.clock.min-quantum = 32;    # Minimum buffer size
        default.clock.max-quantum = 32;    # Maximum buffer size
      };
    };

    # extraConfig.pipewire."99-echo-cancel" = {
    #   "context.modules" = [
    #     {
    #       name = "libpipewire-module-echo-cancel";
    #       args = {
    #         # library.name = "aec/libspa-aec-webrtc" # Có thể bỏ qua để dùng mặc định
    #         # node.latency = "1024/48000"
    #         # monitor.mode = false
    #         sink.master = "alsa_output.usb-Jieli_Technology_USB-Sounbar-V18-00.analog-stereo";
    #         source.master = "alsa_input.usb-Maono_DGM20_USB_Microphone_20230101-00.analog-stereo";

    #         node.description = "Microphone (khử tiếng vang)";
    #         capture.props = {
    #           node.name = "echo_cancelled_source";
    #         };
    #         playback.props = {
    #           node.name = "echo_cancelled_sink";
    #         };
    #         source.props = {
    #           "node.name" = "echo-cancel-source";
    #         };
    #         sink.props = {
    #           "node.name" = "echo-cancel-sink";
    #         };
    #       };
    #     }
    #   ];
    # };

    # extraConfig.pipewire."98-rnnoise" = {
    #   "context.modules" = [
    #     {
    #       name = "libpipewire-module-filter-chain";
    #       args = {
    #         node.description = "Noise Canceling source";
    #         media.name = "Noise Canceling source";
    #         filter.graph = {
    #           nodes = [
    #             {
    #               type = "ladspa";
    #               name = "rnnoise";
    #               plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
    #               label = "noise_suppressor_stereo";
    #               control = {
    #                 "VAD Threshold (%)" = 50.0;
    #               };
    #             }
    #           ];
    #         };
    #         capture.props = {
    #           "node.name" = "rnnoise_capture";
    #         };
    #         playback.props = {
    #           "node.name" = "rnnoise_playback";
    #         };
    #       };
    #     }
    #   ];
    # };
  };

  # === AUDIO UTILITIES ===
  environment.systemPackages = with pkgs; [
    pavucontrol  # PulseAudio Volume Control GUI
    easyeffects  # Audio effects and equalization
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