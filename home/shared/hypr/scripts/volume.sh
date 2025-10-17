#!/run/current-system/sw/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for volume controls for audio and mic 
# Enhanced to work with EasyEffects

iDIR="$HOME/.config/swaync/icons"
sDIR="~/Workspaces/Config/nixos/home/shared/hypr/scripts"

# Lock mechanism to prevent concurrent execution
LOCKFILE="/tmp/volume_control.lock"
LOCKFD=200

# Acquire lock with timeout
acquire_lock() {
    eval "exec $LOCKFD>$LOCKFILE"
    flock -n $LOCKFD || {
        # If lock failed, wait a bit and try once more
        sleep 0.05
        flock -w 1 $LOCKFD || return 1
    }
    return 0
}

# Release lock
release_lock() {
    flock -u $LOCKFD
}

# Get the actual hardware sink (bypassing EasyEffects virtual sink)
get_hardware_sink() {
    # If EasyEffects is the default, find the actual hardware sink it outputs to
    local default_sink=$(pactl get-default-sink)
    
    if [[ "$default_sink" == "easyeffects_sink" ]]; then
        # Find the hardware sink that EasyEffects is connected to
        # First try to find the RUNNING sink (actively playing audio)
        local running_sink=$(pactl list short sinks | command grep "RUNNING" | command grep -E "alsa_output" | command grep -v "easyeffects" | head -n1 | awk '{print $2}')
        
        if [[ -n "$running_sink" ]]; then
            echo "$running_sink"
        else
            # Fallback: get the first non-monitor ALSA output
            pactl list short sinks | command grep -E "alsa_output" | command grep -v "easyeffects" | command grep -v "monitor" | head -n1 | awk '{print $2}'
        fi
    else
        echo "$default_sink"
    fi
}

# Get the actual hardware source (bypassing EasyEffects virtual source)
get_hardware_source() {
    local default_source=$(pactl get-default-source)
    
    if [[ "$default_source" == "easyeffects_source" ]]; then
        # Find the hardware source that EasyEffects is connected to
        # Try to find the active (non-monitor) hardware input
        local hw_source=$(pactl list short sources | command grep -E "alsa_input" | command grep -v "easyeffects" | command grep -v "monitor" | head -n1 | awk '{print $2}')
        
        if [[ -n "$hw_source" ]]; then
            echo "$hw_source"
        else
            # Fallback: get any ALSA input
            pactl list short sources | command grep -E "alsa_input" | command grep -v "easyeffects" | head -n1 | awk '{print $2}'
        fi
    else
        echo "$default_source"
    fi
}

# Get Volume (from hardware sink for actual audio level)
get_volume() {
    local hw_sink=$(get_hardware_sink)
    
    if [[ -n "$hw_sink" ]] && command -v pactl &> /dev/null; then
        # Get volume from hardware sink
        volume=$(pactl list sinks | grep -A 15 "Name: $hw_sink" | grep "Volume:" | head -n1 | awk '{print $5}' | tr -d '%')
        muted=$(pactl list sinks | grep -A 15 "Name: $hw_sink" | grep "Mute:" | awk '{print $2}')
        
        if [[ -z "$volume" ]]; then
            volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
            muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "yes" || echo "no")
        fi
    else
        # Fallback to default sink
        volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
        muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "yes" || echo "no")
    fi
    
    if [[ "$muted" == "yes" ]] || [[ "$muted" == "true" ]] || [[ "$volume" -eq "0" ]]; then
        echo "Muted"
    else
        echo "$volume %"
    fi
}

# Get icons
get_icon() {
    current=$(get_volume)
    if [[ "$current" == "Muted" ]]; then
        echo "$iDIR/volume-mute.png"
    elif [[ "${current%\%}" -le 30 ]]; then
        echo "$iDIR/volume-low.png"
    elif [[ "${current%\%}" -le 60 ]]; then
        echo "$iDIR/volume-mid.png"
    else
        echo "$iDIR/volume-high.png"
    fi
}

# Sync volume from hardware sink to virtual sink (for QuickShell display)
sync_to_virtual_sink() {
    local default_sink=$(pactl get-default-sink)
    
    # Only sync if using EasyEffects
    if [[ "$default_sink" != "easyeffects_sink" ]]; then
        return
    fi
    
    local hw_sink=$(get_hardware_sink)
    if [[ -z "$hw_sink" ]] || [[ "$hw_sink" == "easyeffects_sink" ]]; then
        return
    fi
    
    # Get hardware volume and mute state
    local hw_volume=$(pactl list sinks | command grep -A 15 "Name: $hw_sink" | command grep "Volume:" | head -n1 | awk '{print $5}' | tr -d '%')
    local hw_muted=$(pactl list sinks | command grep -A 15 "Name: $hw_sink" | command grep "Mute:" | awk '{print $2}')
    
    if [[ -n "$hw_volume" ]]; then
        # Sync volume to virtual sink (for QuickShell to display)
        pactl set-sink-volume easyeffects_sink "${hw_volume}%" 2>/dev/null
        
        # Sync mute state
        if [[ "$hw_muted" == "yes" ]]; then
            pactl set-sink-mute easyeffects_sink 1 2>/dev/null
        else
            pactl set-sink-mute easyeffects_sink 0 2>/dev/null
        fi
    fi
}

# Sync volume from hardware source to virtual source (for QuickShell display)
sync_to_virtual_source() {
    local default_source=$(pactl get-default-source)
    
    # Only sync if using EasyEffects
    if [[ "$default_source" != "easyeffects_source" ]]; then
        return
    fi
    
    local hw_source=$(get_hardware_source)
    if [[ -z "$hw_source" ]] || [[ "$hw_source" == "easyeffects_source" ]]; then
        return
    fi
    
    # Get hardware volume and mute state
    local hw_volume=$(pactl list sources | command grep -A 15 "Name: $hw_source" | command grep "Volume:" | head -n1 | awk '{print $5}' | tr -d '%')
    local hw_muted=$(pactl list sources | command grep -A 15 "Name: $hw_source" | command grep "Mute:" | awk '{print $2}')
    
    if [[ -n "$hw_volume" ]]; then
        # Sync volume to virtual source (for QuickShell to display)
        pactl set-source-volume easyeffects_source "${hw_volume}%" 2>/dev/null
        
        # Sync mute state
        if [[ "$hw_muted" == "yes" ]]; then
            pactl set-source-mute easyeffects_source 1 2>/dev/null
        else
            pactl set-source-mute easyeffects_source 0 2>/dev/null
        fi
    fi
}

# Increase Volume (controls hardware sink for actual audio change)
inc_volume() {
    local hw_sink=$(get_hardware_sink)
    
    if [[ -n "$hw_sink" ]] && command -v pactl &> /dev/null; then
        # Control hardware sink directly
        pactl set-sink-mute "$hw_sink" 0  # Unmute if muted
        pactl set-sink-volume "$hw_sink" +5%
        # Sync to virtual sink for QuickShell
        sync_to_virtual_sink
    elif command -v wpctl &> /dev/null; then
        # Fallback to default sink
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | command grep -q "MUTED" && wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    else
        if [ "$(pamixer --get-mute)" == "true" ]; then
            toggle_mute
        else
            pamixer -i 5 --allow-boost --set-limit 150
        fi
    fi
}

# Decrease Volume (controls hardware sink for actual audio change)
dec_volume() {
    local hw_sink=$(get_hardware_sink)
    
    if [[ -n "$hw_sink" ]] && command -v pactl &> /dev/null; then
        # Control hardware sink directly
        pactl set-sink-mute "$hw_sink" 0  # Unmute if muted
        pactl set-sink-volume "$hw_sink" -5%
        # Sync to virtual sink for QuickShell
        sync_to_virtual_sink
    elif command -v wpctl &> /dev/null; then
        # Fallback to default sink
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | command grep -q "MUTED" && wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    else
        if [ "$(pamixer --get-mute)" == "true" ]; then
            toggle_mute
        else
            pamixer -d 5
        fi
    fi
}

# Toggle Mute (controls hardware sink for actual audio change)
toggle_mute() {
    local hw_sink=$(get_hardware_sink)
    
    if [[ -n "$hw_sink" ]] && command -v pactl &> /dev/null; then
        # Toggle hardware sink mute with explicit wait
        pactl set-sink-mute "$hw_sink" toggle
        sleep 0.05  # Small delay to ensure command completes
        # Sync to virtual sink for QuickShell
        sync_to_virtual_sink
    elif command -v wpctl &> /dev/null; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        sleep 0.05
    else
        if [ "$(pamixer --get-mute)" == "false" ]; then
            pamixer -m
        elif [ "$(pamixer --get-mute)" == "true" ]; then
            pamixer -u
        fi
        sleep 0.05
    fi
}

# Toggle Mic (controls hardware source for actual mic change)
toggle_mic() {
    local hw_source=$(get_hardware_source)
    
    if [[ -n "$hw_source" ]] && command -v pactl &> /dev/null; then
        # Toggle hardware source mute
        pactl set-source-mute "$hw_source" toggle
        # Sync to virtual source for QuickShell
        sync_to_virtual_source
    elif command -v wpctl &> /dev/null; then
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    else
        if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
            pamixer --default-source -m
        elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
            pamixer -u --default-source u
        fi
    fi
}

# Get Mic Icon (from hardware source for actual mic state)
get_mic_icon() {
    local hw_source=$(get_hardware_source)
    
    if [[ -n "$hw_source" ]] && command -v pactl &> /dev/null; then
        # Get mute state from hardware source
        muted=$(pactl list sources | command grep -A 15 "Name: $hw_source" | command grep "Mute:" | awk '{print $2}')
        
        if [[ "$muted" == "yes" ]]; then
            echo "$iDIR/microphone-mute.png"
        else
            echo "$iDIR/microphone.png"
        fi
    elif command -v wpctl &> /dev/null; then
        muted=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | command grep -q "MUTED" && echo "yes" || echo "no")
        if [[ "$muted" == "yes" ]]; then
            echo "$iDIR/microphone-mute.png"
        else
            echo "$iDIR/microphone.png"
        fi
    else
        current=$(pamixer --default-source --get-volume)
        if [[ "$current" -eq "0" ]]; then
            echo "$iDIR/microphone-mute.png"
        else
            echo "$iDIR/microphone.png"
        fi
    fi
}

# Get Microphone Volume (from hardware source for actual mic level)
get_mic_volume() {
    local hw_source=$(get_hardware_source)
    
    if [[ -n "$hw_source" ]] && command -v pactl &> /dev/null; then
        # Get volume from hardware source
        volume=$(pactl list sources | command grep -A 15 "Name: $hw_source" | command grep "Volume:" | head -n1 | awk '{print $5}' | tr -d '%')
        muted=$(pactl list sources | command grep -A 15 "Name: $hw_source" | command grep "Mute:" | awk '{print $2}')
        
        if [[ -z "$volume" ]]; then
            volume=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2 * 100)}')
            muted=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | command grep -q "MUTED" && echo "yes" || echo "no")
        fi
    else
        # Fallback to default source
        volume=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2 * 100)}')
        muted=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | command grep -q "MUTED" && echo "yes" || echo "no")
    fi
    
    if [[ "$muted" == "yes" ]] || [[ "$muted" == "true" ]] || [[ "$volume" -eq "0" ]]; then
        echo "Muted"
    else
        echo "$volume %"
    fi
}

# Increase MIC Volume (controls hardware source for actual mic change)
inc_mic_volume() {
    local hw_source=$(get_hardware_source)
    
    if [[ -n "$hw_source" ]] && command -v pactl &> /dev/null; then
        # Control hardware source directly
        pactl set-source-mute "$hw_source" 0  # Unmute if muted
        pactl set-source-volume "$hw_source" +5%
        # Sync to virtual source for QuickShell
        sync_to_virtual_source
    elif command -v wpctl &> /dev/null; then
        # Fallback to default source
        wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | command grep -q "MUTED" && wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+
    else
        if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
            toggle_mic
        else
            pamixer --default-source -i 5 
        fi
    fi
}

# Decrease MIC Volume (controls hardware source for actual mic change)
dec_mic_volume() {
    local hw_source=$(get_hardware_source)
    
    if [[ -n "$hw_source" ]] && command -v pactl &> /dev/null; then
        # Control hardware source directly
        pactl set-source-mute "$hw_source" 0  # Unmute if muted
        pactl set-source-volume "$hw_source" -5%
        # Sync to virtual source for QuickShell
        sync_to_virtual_source
    elif command -v wpctl &> /dev/null; then
        # Fallback to default source
        wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | command grep -q "MUTED" && wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-
    else
        if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
            toggle_mic
        else
            pamiper --default-source -d 5 
        fi
    fi
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	acquire_lock && { inc_volume; release_lock; }
elif [[ "$1" == "--dec" ]]; then
	acquire_lock && { dec_volume; release_lock; }
elif [[ "$1" == "--toggle" ]]; then
	acquire_lock && { toggle_mute; release_lock; }
elif [[ "$1" == "--toggle-mic" ]]; then
	acquire_lock && { toggle_mic; release_lock; }
elif [[ "$1" == "--get-icon" ]]; then
	get_icon
elif [[ "$1" == "--get-mic-icon" ]]; then
	get_mic_icon
elif [[ "$1" == "--mic-inc" ]]; then
	acquire_lock && { inc_mic_volume; release_lock; }
elif [[ "$1" == "--mic-dec" ]]; then
	acquire_lock && { dec_mic_volume; release_lock; }
else
	get_volume
fi