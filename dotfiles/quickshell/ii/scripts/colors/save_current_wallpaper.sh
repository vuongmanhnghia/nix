#!/usr/bin/env bash

# Script to save current wallpaper to ~/Pictures/wpp

get_pictures_dir() {
    if command -v xdg-user-dir &> /dev/null; then
        xdg-user-dir PICTURES
        return
    fi

    local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
    if [ -f "$config_file" ]; then
        local pictures_path
        pictures_path=$(source "$config_file" >/dev/null 2>&1; echo "$XDG_PICTURES_DIR")
        echo "${pictures_path/#\$HOME/$HOME}"
        return
    fi

    echo "$HOME/Pictures"
}

PICTURES_DIR=$(get_pictures_dir)
WPP_DIR="$PICTURES_DIR/wpp"
CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"

# Create wpp directory if it doesn't exist
mkdir -p "$WPP_DIR"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found at $CONFIG_FILE" >&2
    exit 1
fi

# Get current wallpaper path from config
CURRENT_WALLPAPER=$(jq -r '.background.wallpaperPath' "$CONFIG_FILE" 2>/dev/null)

if [ -z "$CURRENT_WALLPAPER" ] || [ "$CURRENT_WALLPAPER" = "null" ]; then
    echo "Error: Could not get current wallpaper path from config" >&2
    exit 1
fi

if [ ! -f "$CURRENT_WALLPAPER" ]; then
    echo "Error: Current wallpaper file does not exist: $CURRENT_WALLPAPER" >&2
    exit 1
fi

# Get file extension
EXT=$(echo "$CURRENT_WALLPAPER" | awk -F. '{print $NF}')
if [ -z "$EXT" ]; then
    EXT="jpg"
fi

# Generate timestamp for filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SAVED_PATH="$WPP_DIR/wallpaper_$TIMESTAMP.$EXT"

# Copy the file
if cp "$CURRENT_WALLPAPER" "$SAVED_PATH"; then
    echo "✅ Wallpaper saved successfully!"
    echo "📁 Location: $SAVED_PATH"
    echo "📄 Original: $CURRENT_WALLPAPER"
    
    # Send notification
    if command -v notify-send &> /dev/null; then
        notify-send "Wallpaper Saved" "Saved to ~/Pictures/wpp/" -a "Shell" -i "image-x-generic"
    fi
else
    echo "❌ Error: Failed to copy wallpaper" >&2
    exit 1
fi
