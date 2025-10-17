{ config, lib, pkgs, ... }:

{
  # === WIREPLUMBER CONFIGURATION FOR EASYEFFECTS ===
  # Sync volume between EasyEffects virtual sink and hardware sink
  
  # Create WirePlumber configuration to link volumes
  home.file.".config/wireplumber/main.lua.d/51-easyeffects-volume-sync.lua".text = ''
    -- Auto-sync volume between EasyEffects virtual sink and hardware sink
    -- This allows QuickShell and other apps to control volume via EasyEffects sink
    
    rule = {
      matches = {
        {
          { "node.name", "equals", "easyeffects_sink" },
        },
      },
      apply_properties = {
        -- Link volume changes to connected nodes
        ["node.link-volume-group"] = "easyeffects-out",
      },
    }

    table.insert(alsa_monitor.rules, rule)
  '';
}
