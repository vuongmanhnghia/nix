#!/usr/bin/env bash

# Process locking to prevent concurrent executions
LOCK_FILE="/tmp/switchwall.lock"
LOCK_TIMEOUT=30

acquire_lock() {
    local timeout=$1
    local count=0
    
    while [ $count -lt $timeout ]; do
        if (set -C; echo $$ > "$LOCK_FILE") 2>/dev/null; then
            trap 'rm -f "$LOCK_FILE"; exit $?' INT TERM EXIT
            return 0
        fi
        
        # Check if existing lock is stale (process doesn't exist)
        if [ -f "$LOCK_FILE" ]; then
            local lock_pid=$(cat "$LOCK_FILE" 2>/dev/null)
            if ! kill -0 "$lock_pid" 2>/dev/null; then
                echo "Removing stale lock file"
                rm -f "$LOCK_FILE"
                continue
            fi
        fi
        
        echo "Waiting for another switchwall process to complete... ($count/$timeout)"
        sleep 1
        ((count++))
    done
    
    echo "Failed to acquire lock after $timeout seconds"
    return 1
}

# Acquire lock or exit
if ! acquire_lock $LOCK_TIMEOUT; then
    echo "Another switchwall process is running. Exiting."
    exit 1
fi

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

# Optimized function to reload kitty with caching
reload_kitty() {
    if ! pidof kitty >/dev/null 2>&1; then
        echo "ℹ️  Kitty is not running"
        return 0
    fi
    
    echo "🔄 Reloading kitty..."
    
    # Cache kitty config path
    local kitty_config="/home/nagih/Workspaces/Config/nixos/generated/kitty.conf"
    if [ ! -f "$kitty_config" ]; then
        echo "⚠️  Kitty config not found: $kitty_config"
        return 1
    fi
    
    # Optimized socket detection with caching
    local socket_path=""
    local socket_cache="/tmp/kitty-socket-cache"
    
    # Try cached socket first
    if [ -f "$socket_cache" ]; then
        local cached_socket=$(cat "$socket_cache")
        if [ -S "$cached_socket" ]; then
            socket_path="$cached_socket"
        else
            rm -f "$socket_cache"
        fi
    fi
    
    # Find socket if not cached
    if [ -z "$socket_path" ]; then
        for socket in /tmp/kitty-socket*; do
            if [ -S "$socket" ]; then
                socket_path="$socket"
                echo "$socket_path" > "$socket_cache"
                break
            fi
        done
    fi
    
    # Try remote control methods in order of preference
    if [ -n "$socket_path" ]; then
        if timeout 2 kitten @ --to "unix:$socket_path" set-colors "$kitty_config" 2>/dev/null; then
            echo "✅ Kitty colors applied via remote control (socket: $(basename "$socket_path"))"
            return 0
        elif timeout 2 kitten @ --to "unix:$socket_path" load-config 2>/dev/null; then
            echo "✅ Kitty config reloaded via remote control (socket: $(basename "$socket_path"))"
            return 0
        else
            # Socket might be stale, remove cache
            rm -f "$socket_cache"
        fi
    fi
    
    # Try auto-detection method
    if timeout 2 kitten @ set-colors "$kitty_config" 2>/dev/null; then
        echo "✅ Kitty colors applied via remote control (auto)"
        return 0
    elif timeout 2 kitten @ load-config 2>/dev/null; then
        echo "✅ Kitty config reloaded via remote control (auto)"
        return 0
    fi
    
    # Fallback to SIGUSR1 signal
    if kill -SIGUSR1 $(pidof kitty) 2>/dev/null; then
        echo "✅ Kitty reloaded via signal"
        return 0
    fi
    
    echo "⚠️  Could not reload kitty"
    return 1
}

# Function to convert SCSS colors to JSON format for quickshell
convert_scss_to_json() {
    local scss_file="$STATE_DIR/user/generated/material_colors.scss"
    local json_file="$STATE_DIR/user/generated/colors.json"
    
    if [ ! -f "$scss_file" ]; then
        echo "Warning: SCSS file not found at $scss_file, skipping JSON conversion"
        return 0
    fi
    
    echo "Converting SCSS to JSON..."
    
    # Simple conversion using awk
    awk '
    BEGIN { print "{" }
    /^\$[^:]*:[^;]*;/ {
        gsub(/^\$/, "", $0)
        gsub(/;$/, "", $0)
        split($0, parts, ":")
        key = parts[1]
        value = parts[2]
        gsub(/^[ \t]+|[ \t]+$/, "", key)
        gsub(/^[ \t]+|[ \t]+$/, "", value)
        if (NR > 1) print ","
        printf "  \"%s\": \"%s\"", key, value
    }
    END { print "\n}" }
    ' "$scss_file" > "$json_file"
    
    echo "Converted SCSS to JSON: $json_file"
}

# Optimized function to notify quickshell to reload theme
notify_quickshell_reload() {
    # Check if quickshell is running first (faster than trying IPC)
    if ! pgrep -f "quickshell.*ii" >/dev/null 2>&1; then
        echo "⚠️  Quickshell is not running, skipping IPC notification"
        return 0
    fi
    
    # Try to send IPC command with timeout
    if command -v quickshell >/dev/null 2>&1; then
        echo "🔔 Notifying quickshell to reload theme..."
        if timeout 3 quickshell -i ~/.config/quickshell/ii --socket=/tmp/quickshell/ii-socket --ipc reloadTheme 2>/dev/null; then
            echo "✅ Quickshell notified successfully"
        else
            echo "⚠️  Could not send IPC command to quickshell (timeout or connection failed)"
            # Fallback: Touch the colors file to trigger FileView
            touch ~/.local/state/quickshell/user/generated/colors.json 2>/dev/null && \
                echo "📁 Triggered file-based reload as fallback"
        fi
    else
        echo "⚠️  Quickshell command not found"
        return 1
    fi
}

handle_kde_material_you_colors() {
    # Check if Qt app theming is enabled in config
    if [ -f "$SHELL_CONFIG_FILE" ]; then
        enable_qt_apps=$(jq -r '.appearance.wallpaperTheming.enableQtApps' "$SHELL_CONFIG_FILE")
        if [ "$enable_qt_apps" == "false" ]; then
            return
        fi
    fi

    # Map $type_flag to allowed scheme variants for kde-material-you-colors-wrapper.sh
    local kde_scheme_variant=""
    case "$type_flag" in
        scheme-content|scheme-expressive|scheme-fidelity|scheme-fruit-salad|scheme-monochrome|scheme-neutral|scheme-rainbow|scheme-tonal-spot)
            kde_scheme_variant="$type_flag"
            ;;
        *)
            kde_scheme_variant="scheme-tonal-spot" # default
            ;;
    esac
    "$XDG_CONFIG_HOME"/matugen/templates/kde/kde-material-you-colors-wrapper.sh --scheme-variant "$kde_scheme_variant"
}

pre_process() {
    local mode_flag="$1"
    # Set GNOME color-scheme if mode_flag is dark or light
    if [[ "$mode_flag" == "dark" ]]; then
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    elif [[ "$mode_flag" == "light" ]]; then
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
        gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
    fi

    if [ ! -d "$CACHE_DIR"/user/generated ]; then
        mkdir -p "$CACHE_DIR"/user/generated
    fi
}

post_process() {
    local screen_width="$1"
    local screen_height="$2"
    local wallpaper_path="$3"


    handle_kde_material_you_colors &

    # Determine the largest region on the wallpaper that's sufficiently un-busy to put widgets in
    # if [ ! -f "$MATUGEN_DIR/scripts/least_busy_region.py" ]; then
    #     echo "Error: least_busy_region.py script not found in $MATUGEN_DIR/scripts/"
    # else
    #     "$MATUGEN_DIR/scripts/least_busy_region.py" \
    #         --screen-width "$screen_width" --screen-height "$screen_height" \
    #         --width 300 --height 200 \
    #         "$wallpaper_path" > "$STATE_DIR"/user/generated/wallpaper/least_busy_region.json
    # fi
}

check_and_prompt_upscale() {
    local img="$1"
    min_width_desired="$(hyprctl monitors -j | jq '([.[].width] | max)' | xargs)" # max monitor width
    min_height_desired="$(hyprctl monitors -j | jq '([.[].height] | max)' | xargs)" # max monitor height

    if command -v identify &>/dev/null && [ -f "$img" ]; then
        local img_width img_height
        if is_video "$img"; then # Not check resolution for videos, just let em pass
            img_width=$min_width_desired
            img_height=$min_height_desired
        else
            img_width=$(identify -format "%w" "$img" 2>/dev/null)
            img_height=$(identify -format "%h" "$img" 2>/dev/null)
        fi
        if [[ "$img_width" -lt "$min_width_desired" || "$img_height" -lt "$min_height_desired" ]]; then
            action=$(notify-send "Upscale?" \
                "Image resolution (${img_width}x${img_height}) is lower than screen resolution (${min_width_desired}x${min_height_desired})" \
                -A "open_upscayl=Open Upscayl"\
                -a "Wallpaper switcher")
            if [[ "$action" == "open_upscayl" ]]; then
                if command -v upscayl &>/dev/null; then
                    nohup upscayl > /dev/null 2>&1 &
                else
                    action2=$(notify-send \
                        -a "Wallpaper switcher" \
                        -c "im.error" \
                        -A "install_upscayl=Install Upscayl (Arch)" \
                        "Install Upscayl?" \
                        "yay -S upscayl-bin")
                    if [[ "$action2" == "install_upscayl" ]]; then
                        kitty -1 yay -S upscayl-bin
                        if command -v upscayl &>/dev/null; then
                            nohup upscayl > /dev/null 2>&1 &
                        fi
                    fi
                fi
            fi
        fi
    fi
}

CUSTOM_DIR="$XDG_CONFIG_HOME/hypr/custom"
RESTORE_SCRIPT_DIR="$CUSTOM_DIR/scripts"
RESTORE_SCRIPT="$RESTORE_SCRIPT_DIR/__restore_video_wallpaper.sh"
THUMBNAIL_DIR="$RESTORE_SCRIPT_DIR/mpvpaper_thumbnails"
VIDEO_OPTS="no-audio loop hwdec=auto scale=bilinear interpolation=no video-sync=display-resample panscan=1.0 video-scale-x=1.0 video-scale-y=1.0 video-align-x=0.5 video-align-y=0.5 load-scripts=no"

is_video() {
    local extension="${1##*.}"
    [[ "$extension" == "mp4" || "$extension" == "webm" || "$extension" == "mkv" || "$extension" == "avi" || "$extension" == "mov" ]] && return 0 || return 1
}

kill_existing_mpvpaper() {
    pkill -f -9 mpvpaper || true
}

create_restore_script() {
    local video_path=$1
    cat > "$RESTORE_SCRIPT.tmp" << EOF
#!/bin/bash
# Generated by switchwall.sh - Don't modify it by yourself.
# Time: $(date)

pkill -f -9 mpvpaper

for monitor in \$(hyprctl monitors -j | jq -r '.[] | .name'); do
    mpvpaper -o "$VIDEO_OPTS" "\$monitor" "$video_path" &
    sleep 0.1
done
EOF
    mv "$RESTORE_SCRIPT.tmp" "$RESTORE_SCRIPT"
    chmod +x "$RESTORE_SCRIPT"
}

remove_restore() {
    cat > "$RESTORE_SCRIPT.tmp" << EOF
#!/bin/bash
# The content of this script will be generated by switchwall.sh - Don't modify it by yourself.
EOF
    mv "$RESTORE_SCRIPT.tmp" "$RESTORE_SCRIPT"
}

set_wallpaper_path() {
    local path="$1"
    if [ -f "$SHELL_CONFIG_FILE" ]; then
        jq --arg path "$path" '.background.wallpaperPath = $path' "$SHELL_CONFIG_FILE" > "$SHELL_CONFIG_FILE.tmp" && mv "$SHELL_CONFIG_FILE.tmp" "$SHELL_CONFIG_FILE"
    fi
}

set_thumbnail_path() {
    local path="$1"
    if [ -f "$SHELL_CONFIG_FILE" ]; then
        jq --arg path "$path" '.background.thumbnailPath = $path' "$SHELL_CONFIG_FILE" > "$SHELL_CONFIG_FILE.tmp" && mv "$SHELL_CONFIG_FILE.tmp" "$SHELL_CONFIG_FILE"
    fi
}

switch() {
    imgpath="$1"
    mode_flag="$2"
    type_flag="$3"
    color_flag="$4"
    color="$5"
    read scale screenx screeny screensizey < <(hyprctl monitors -j | jq '.[] | select(.focused) | .scale, .x, .y, .height' | xargs)
    cursorposx=$(hyprctl cursorpos -j | jq '.x' 2>/dev/null) || cursorposx=960
    cursorposx=$(bc <<< "scale=0; ($cursorposx - $screenx) * $scale / 1")
    cursorposy=$(hyprctl cursorpos -j | jq '.y' 2>/dev/null) || cursorposy=540
    cursorposy=$(bc <<< "scale=0; ($cursorposy - $screeny) * $scale / 1")
    cursorposy_inverted=$((screensizey - cursorposy))

    if [[ "$color_flag" == "1" ]]; then
        matugen_args=(color hex "$color")
        generate_colors_material_args=(--color "$color")
    else
        if [[ -z "$imgpath" ]]; then
            echo 'Aborted'
            exit 0
        fi

        check_and_prompt_upscale "$imgpath" &
        kill_existing_mpvpaper

        if is_video "$imgpath"; then
            mkdir -p "$THUMBNAIL_DIR"

            missing_deps=()
            if ! command -v mpvpaper &> /dev/null; then
                missing_deps+=("mpvpaper")
            fi
            if ! command -v ffmpeg &> /dev/null; then
                missing_deps+=("ffmpeg")
            fi
            if [ ${#missing_deps[@]} -gt 0 ]; then
                echo "Missing deps: ${missing_deps[*]}"
                echo "Arch: sudo pacman -S ${missing_deps[*]}"
                action=$(notify-send \
                    -a "Wallpaper switcher" \
                    -c "im.error" \
                    -A "install_arch=Install (Arch)" \
                    "Can't switch to video wallpaper" \
                    "Missing dependencies: ${missing_deps[*]}")
                if [[ "$action" == "install_arch" ]]; then
                    kitty -1 sudo pacman -S "${missing_deps[*]}"
                    if command -v mpvpaper &>/dev/null && command -v ffmpeg &>/dev/null; then
                        notify-send 'Wallpaper switcher' 'Alright, try again!' -a "Wallpaper switcher"
                    fi
                fi
                exit 0
            fi

            # Set wallpaper path
            set_wallpaper_path "$imgpath"

            # Set video wallpaper
            local video_path="$imgpath"
            monitors=$(hyprctl monitors -j | jq -r '.[] | .name')
            for monitor in $monitors; do
                mpvpaper -o "$VIDEO_OPTS" "$monitor" "$video_path" &
                sleep 0.1
            done

            # Extract first frame for color generation
            thumbnail="$THUMBNAIL_DIR/$(basename "$imgpath").jpg"
            ffmpeg -y -i "$imgpath" -vframes 1 "$thumbnail" 2>/dev/null

            # Set thumbnail path
            set_thumbnail_path "$thumbnail"

            if [ -f "$thumbnail" ]; then
                matugen_args=(image "$thumbnail")
                generate_colors_material_args=(--path "$thumbnail")
                create_restore_script "$video_path"
            else
                echo "Cannot create image to colorgen"
                remove_restore
                exit 1
            fi
        else
            matugen_args=(image "$imgpath")
            generate_colors_material_args=(--path "$imgpath")
            # Update wallpaper path in config
            set_wallpaper_path "$imgpath"
            remove_restore
        fi
    fi

    # Determine mode if not set
    if [[ -z "$mode_flag" ]]; then
        current_mode=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null | tr -d "'")
        if [[ "$current_mode" == "prefer-dark" ]]; then
            mode_flag="dark"
        else
            mode_flag="light"
        fi
    fi

    [[ -n "$mode_flag" ]] && matugen_args+=(--mode "$mode_flag") && generate_colors_material_args+=(--mode "$mode_flag")
    [[ -n "$type_flag" ]] && matugen_args+=(--type "$type_flag") && generate_colors_material_args+=(--scheme "$type_flag")
    generate_colors_material_args+=(--termscheme "$terminalscheme" --blend_bg_fg)
    generate_colors_material_args+=(--cache "$STATE_DIR/user/generated/color.txt")

    pre_process "$mode_flag"

    # Check if app and shell theming is enabled in config
    if [ -f "$SHELL_CONFIG_FILE" ]; then
        enable_apps_shell=$(jq -r '.appearance.wallpaperTheming.enableAppsAndShell' "$SHELL_CONFIG_FILE")
        if [ "$enable_apps_shell" == "false" ]; then
            echo "App and shell theming disabled, skipping matugen and color generation"
            return
        fi
    fi

    matugen "${matugen_args[@]}"
    source "$(eval echo $ILLOGICAL_IMPULSE_VIRTUAL_ENV)/bin/activate"
    python3 "$SCRIPT_DIR/generate_colors_material.py" "${generate_colors_material_args[@]}" \
        > "$STATE_DIR/user/generated/material_colors.scss" 2>/dev/null
    
    # Convert SCSS to JSON for quickshell
    convert_scss_to_json
    
    "$SCRIPT_DIR"/applycolor.sh
    deactivate

    # Notify quickshell to reload theme
    notify_quickshell_reload
    
    # Notify other applications
    echo "Notifying applications to reload themes..."
    
    # Reload hyprland
    hyprctl reload 2>/dev/null && echo "Hyprland reloaded" || echo "Could not reload Hyprland"
    
    # Reload kitty
    reload_kitty
    
    # Reload wallpaper daemon
    if pidof swww >/dev/null 2>&1; then
        kill -SIGUSR1 $(pidof swww) 2>/dev/null && echo "Wallpaper daemon reloaded" || echo "Could not reload wallpaper daemon"
    fi

    # Handle KDE Material You colors
    handle_kde_material_you_colors

    # Pass screen width, height, and wallpaper path to post_process
    max_width_desired="$(hyprctl monitors -j | jq '([.[].width] | min)' | xargs)"
    max_height_desired="$(hyprctl monitors -j | jq '([.[].height] | min)' | xargs)"
    post_process "$max_width_desired" "$max_height_desired" "$imgpath"
    
    # Final notification
    notify-send "Theme Applied" "Colors and themes have been successfully updated from wallpaper" -i "preferences-color" 2>/dev/null || true
}

main() {
    imgpath=""
    mode_flag=""
    type_flag=""
    color_flag=""
    color=""
    noswitch_flag=""

    get_type_from_config() {
        jq -r '.appearance.palette.type' "$SHELL_CONFIG_FILE" 2>/dev/null || echo "auto"
    }

    detect_scheme_type_from_image() {
        local img="$1"
        "$SCRIPT_DIR"/scheme_for_image.py "$img" 2>/dev/null | tr -d '\n'
    }

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --mode)
                mode_flag="$2"
                shift 2
                ;;
            --type)
                type_flag="$2"
                shift 2
                ;;
            --color)
                color_flag="1"
                if [[ "$2" =~ ^#?[A-Fa-f0-9]{6}$ ]]; then
                    color="$2"
                    shift 2
                else
                    color=$(hyprpicker --no-fancy)
                    shift
                fi
                ;;
            --image)
                imgpath="$2"
                shift 2
                ;;
            --noswitch)
                noswitch_flag="1"
                imgpath=$(jq -r '.background.wallpaperPath' "$SHELL_CONFIG_FILE" 2>/dev/null || echo "")
                shift
                ;;
            *)
                if [[ -z "$imgpath" ]]; then
                    imgpath="$1"
                fi
                shift
                ;;
        esac
    done

    # If type_flag is not set, get it from config
    if [[ -z "$type_flag" ]]; then
        type_flag="$(get_type_from_config)"
    fi

    # Validate type_flag (allow 'auto' as well)
    allowed_types=(scheme-content scheme-expressive scheme-fidelity scheme-fruit-salad scheme-monochrome scheme-neutral scheme-rainbow scheme-tonal-spot auto)
    valid_type=0
    for t in "${allowed_types[@]}"; do
        if [[ "$type_flag" == "$t" ]]; then
            valid_type=1
            break
        fi
    done
    if [[ $valid_type -eq 0 ]]; then
        echo "[switchwall.sh] Warning: Invalid type '$type_flag', defaulting to 'auto'" >&2
        type_flag="auto"
    fi

    # Only prompt for wallpaper if not using --color and not using --noswitch and no imgpath set
    if [[ -z "$imgpath" && -z "$color_flag" && -z "$noswitch_flag" ]]; then
        cd "$(xdg-user-dir PICTURES)/Wallpapers/showcase" 2>/dev/null || cd "$(xdg-user-dir PICTURES)/Wallpapers" 2>/dev/null || cd "$(xdg-user-dir PICTURES)" || return 1
        imgpath="$(kdialog --getopenfilename . --title 'Choose wallpaper')"
    fi

    # If type_flag is 'auto', detect scheme type from image (after imgpath is set)
    if [[ "$type_flag" == "auto" ]]; then
        if [[ -n "$imgpath" && -f "$imgpath" ]]; then
            detected_type="$(detect_scheme_type_from_image "$imgpath")"
            # Only use detected_type if it's valid
            valid_detected=0
            for t in "${allowed_types[@]}"; do
                if [[ "$detected_type" == "$t" && "$detected_type" != "auto" ]]; then
                    valid_detected=1
                    break
                fi
            done
            if [[ $valid_detected -eq 1 ]]; then
                type_flag="$detected_type"
            else
                echo "[switchwall] Warning: Could not auto-detect a valid scheme, defaulting to 'scheme-tonal-spot'" >&2
                type_flag="scheme-tonal-spot"
            fi
        else
            echo "[switchwall] Warning: No image to auto-detect scheme from, defaulting to 'scheme-tonal-spot'" >&2
            type_flag="scheme-tonal-spot"
        fi
    fi

    switch "$imgpath" "$mode_flag" "$type_flag" "$color_flag" "$color"
}

main "$@"
