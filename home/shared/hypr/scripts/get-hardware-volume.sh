#!/usr/bin/env bash
# ============================================================================
# QuickShell Hardware Volume Monitor
# ============================================================================
# Purpose: Continuously monitor hardware sink/source volume for QuickShell
# Usage: get-hardware-volume.sh [--sink|--source]
# Output: JSON format: {"volume": 0.70, "muted": false}
# ============================================================================

set -euo pipefail

# Get hardware sink (speakers) ID
get_hardware_sink() {
    # Check if EasyEffects virtual sink exists
    local easyeffects_active
    easyeffects_active=$(wpctl status | grep -c "Easy Effects Sink" || true)
    
    if [[ "$easyeffects_active" -gt 0 ]]; then
        # EasyEffects is active, find hardware sink
        wpctl status | awk '/Sinks:/{flag=1; next} /Sources:/{flag=0} flag && /USB-Sounbar-V18/ {print $2}' | tr -d '*.'
    else
        # No EasyEffects, use default
        wpctl status | awk '/Sinks:/{flag=1; next} /Sources:/{flag=0} flag && /\*/ {print $2}' | head -n1 | tr -d '*.'
    fi
}

# Get hardware source (microphone) ID
get_hardware_source() {
    # Check if EasyEffects virtual source exists
    local easyeffects_active
    easyeffects_active=$(wpctl status | grep -c "Easy Effects Source" || true)
    
    if [[ "$easyeffects_active" -gt 0 ]]; then
        # EasyEffects is active, find hardware source
        wpctl status | awk '/Sources:/{flag=1; next} /Sink endpoints:/{flag=0} flag && /DGM20/ {print $2}' | tr -d '*.'
    else
        # No EasyEffects, use default
        wpctl status | awk '/Sources:/{flag=1; next} /Sink endpoints:/{flag=0} flag && /\*/ && !/Monitor/ {print $2}' | head -n1 | tr -d '*.'
    fi
}

# Get volume and mute status
get_device_info() {
    local device_id=$1
    
    if [[ -z "$device_id" ]]; then
        echo "{\"volume\": 0.0, \"muted\": true}"
        return
    fi
    
    local volume_info
    local muted="false"
    
    volume_info=$(wpctl get-volume "$device_id" 2>/dev/null || echo "Volume: 0.0")
    
    # Parse volume (e.g., "Volume: 0.70")
    local volume
    volume=$(echo "$volume_info" | awk '{print $2}')
    
    # Check if muted
    if echo "$volume_info" | grep -q "MUTED"; then
        muted="true"
    fi
    
    # Output JSON
    echo "{\"volume\": ${volume:-0.0}, \"muted\": $muted}"
}

# Main function
main() {
    local mode="${1:---sink}"
    
    case "$mode" in
        --sink)
            local sink_id
            sink_id=$(get_hardware_sink)
            if [[ -n "$sink_id" ]]; then
                get_device_info "$sink_id"
            else
                echo "{\"volume\": 0.0, \"muted\": true}"
            fi
            ;;
        --source)
            local source_id
            source_id=$(get_hardware_source)
            if [[ -n "$source_id" ]]; then
                get_device_info "$source_id"
            else
                echo "{\"volume\": 0.0, \"muted\": true}"
            fi
            ;;
        --watch)
            # Continuous monitoring mode for QuickShell
            while true; do
                echo "SINK: $(get_hardware_sink | xargs -I {} wpctl get-volume {})"
                echo "SOURCE: $(get_hardware_source | xargs -I {} wpctl get-volume {})"
                sleep 0.1
            done
            ;;
        *)
            echo "Usage: $0 [--sink|--source|--watch]"
            exit 1
            ;;
    esac
}

main "$@"
