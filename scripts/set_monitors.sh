#!/usr/bin/env bash
export PORT_NAME=$(xrandr | grep " connected" | head -1 | awk '{print $1}')
export RESOLUTION=$(xrandr | grep " connected" | head -1 | awk '{print $3}' | cut -d '+' -f 1)
export REFRESH_RATE=$(xrandr | grep -oP '\d+\.\d+(?=[*+ ])' | sort -rn | head -n 1)

hyprctl keyword monitor "$PORT_NAME, ${RESOLUTION}@${REFRESH_RATE}, 0x0, 1, bitdepth, 8"