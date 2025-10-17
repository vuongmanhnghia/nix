#!/run/current-system/sw/bin/bash
# Sync volume from hardware sink to EasyEffects virtual sink
# This allows QuickShell to display correct volume

# Get hardware sink name
get_hardware_sink() {
    local default_sink=$(pactl get-default-sink)
    
    if [[ "$default_sink" == "easyeffects_sink" ]]; then
        pactl list short sinks | command grep "RUNNING" | command grep -E "alsa_output" | command grep -v "easyeffects" | head -n1 | awk '{print $2}'
        
        if [[ -z "$RUNNING_SINK" ]]; then
            pactl list short sinks | command grep -E "alsa_output" | command grep -v "easyeffects" | command grep -v "monitor" | head -n1 | awk '{print $2}'
        fi
    else
        echo "$default_sink"
    fi
}

# Monitor hardware sink volume changes and sync to virtual sink
monitor_and_sync() {
    local hw_sink=$(get_hardware_sink)
    
    if [[ -z "$hw_sink" ]] || [[ "$hw_sink" == "easyeffects_sink" ]]; then
        echo "No hardware sink found or not using EasyEffects. Exiting."
        exit 0
    fi
    
    echo "Monitoring volume on: $hw_sink"
    echo "Syncing to: easyeffects_sink"
    
    # Subscribe to PipeWire events
    pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "sink.*change"; then
            # Get hardware sink volume
            hw_volume=$(pactl list sinks | grep -A 15 "Name: $hw_sink" | grep "Volume:" | head -n1 | awk '{print $5}' | tr -d '%')
            hw_muted=$(pactl list sinks | grep -A 15 "Name: $hw_sink" | grep "Mute:" | awk '{print $2}')
            
            if [[ -n "$hw_volume" ]]; then
                # Sync to EasyEffects virtual sink
                pactl set-sink-volume easyeffects_sink "${hw_volume}%"
                
                # Sync mute state
                if [[ "$hw_muted" == "yes" ]]; then
                    pactl set-sink-mute easyeffects_sink 1
                else
                    pactl set-sink-mute easyeffects_sink 0
                fi
            fi
        fi
    done
}

# Run in background
monitor_and_sync &
