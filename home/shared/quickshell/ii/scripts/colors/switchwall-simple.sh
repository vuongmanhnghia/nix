#!/usr/bin/env bash

# Simple wallpaper switcher - backup version
QUICKSHELL_CONFIG_NAME="ii"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
CONFIG_DIR="$XDG_CONFIG_HOME/quickshell/$QUICKSHELL_CONFIG_NAME"
CACHE_DIR="$XDG_CACHE_HOME/quickshell"
STATE_DIR="$XDG_STATE_HOME/quickshell"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_CONFIG_FILE="$XDG_CONFIG_HOME/illogical-impulse/config.json"
MATUGEN_DIR="$XDG_CONFIG_HOME/matugen"
terminalscheme="$SCRIPT_DIR/terminal/scheme-base.json"

# Simple function to reload kitty
reload_kitty_simple() {
    if pidof kitty >/dev/null 2>&1; then
        echo "🔄 Reloading kitty..."
        
        # Find socket
        for socket in /tmp/kitty-socket*; do
            if [ -S "$socket" ] && kitten @ --to "unix:$socket" load-config 2>/dev/null; then
                echo "✅ Kitty reloaded via socket"
                return 0
            fi
        done
        
        # Fallback to signal
        if kill -SIGUSR1 $(pidof kitty) 2>/dev/null; then
            echo "✅ Kitty reloaded via signal"
        else
            echo "⚠️  Could not reload kitty"
        fi
    fi
}

# Simple wallpaper change function
change_wallpaper() {
    local imgpath="$1"
    
    if [ -z "$imgpath" ]; then
        echo "❌ No image path provided"
        return 1
    fi
    
    if [ ! -f "$imgpath" ]; then
        echo "❌ Image file not found: $imgpath"
        return 1
    fi
    
    echo "🖼️  Changing wallpaper to: $imgpath"
    
    # Use swww to change wallpaper
    if command -v swww >/dev/null 2>&1; then
        swww img "$imgpath" --transition-type fade --transition-duration 1
        echo "✅ Wallpaper changed"
    else
        echo "❌ swww not found"
        return 1
    fi
    
    # Try to run matugen
    if command -v matugen >/dev/null 2>&1; then
        echo "🎨 Generating colors..."
        matugen image "$imgpath" --mode dark 2>/dev/null && echo "✅ Colors generated" || echo "⚠️  Color generation failed"
    fi
    
    # Reload kitty
    reload_kitty_simple
    
    # Reload hyprland
    if command -v hyprctl >/dev/null 2>&1; then
        hyprctl reload 2>/dev/null && echo "✅ Hyprland reloaded" || echo "⚠️  Hyprland reload failed"
    fi
    
    echo "✨ Wallpaper change complete!"
}

# Parse arguments
imgpath=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --image)
            imgpath="$2"
            shift 2
            ;;
        *)
            if [[ -z "$imgpath" ]]; then
                imgpath="$1"
            fi
            shift
            ;;
    esac
done

# If no image provided, try to select one
if [[ -z "$imgpath" ]]; then
    if command -v kdialog >/dev/null 2>&1; then
        cd "$(xdg-user-dir PICTURES)/Wallpapers" 2>/dev/null || cd "$(xdg-user-dir PICTURES)" || cd "$HOME"
        imgpath="$(kdialog --getopenfilename . --title 'Choose wallpaper')"
    else
        echo "❌ No image provided and kdialog not available"
        echo "Usage: $0 --image /path/to/image.jpg"
        exit 1
    fi
fi

# Change wallpaper
change_wallpaper "$imgpath" 