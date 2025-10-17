{ config, lib, pkgs, ... }:

{
  # === EASY EFFECTS CONFIGURATION ===
  # Audio effects processor for PipeWire
  
  # Enable EasyEffects service (runs in background)
  services.easyeffects = {
    enable = true;
    # Auto-start EasyEffects with the session
    # Note: Already configured in autostart.nix, but this ensures it's properly managed
  };

  # Install additional audio processing packages
  home.packages = with pkgs; [
    # Additional plugins for EasyEffects
    lsp-plugins     # Linux Studio Plugins (EQ, Compressor, etc.)
    calf            # Calf Studio Gear plugins
    mda_lv2         # MDA LV2 plugins
    zam-plugins     # ZamAudio plugins
  ];

  # Create EasyEffects presets directory
  home.file.".config/easyeffects/output/.keep".text = "";
  home.file.".config/easyeffects/input/.keep".text = "";

  # Optional: Create a basic preset for general audio enhancement
  home.file.".config/easyeffects/output/general_enhancement.json".text = builtins.toJSON {
    output = {
      blocklist = [];
      plugins_order = [
        "autogain"
        "bass_enhancer"
        "compressor"
        "equalizer"
      ];
      autogain = {
        bypass = false;
        input-gain = 0.0;
        output-gain = 0.0;
        target = -23.0;
      };
      bass_enhancer = {
        bypass = false;
        amount = 0.0;
        blend = 0.0;
        floor = 20.0;
        floor-active = false;
        harmonics = 8.5;
        input-gain = 0.0;
        output-gain = 0.0;
        scope = 100.0;
      };
      compressor = {
        bypass = false;
        attack = 20.0;
        knee = -6.0;
        makeup = 0.0;
        ratio = 4.0;
        release = 100.0;
        threshold = -20.0;
      };
      equalizer = {
        bypass = false;
        input-gain = 0.0;
        output-gain = 0.0;
        num-bands = 10;
        split-channels = false;
      };
    };
  };
}
