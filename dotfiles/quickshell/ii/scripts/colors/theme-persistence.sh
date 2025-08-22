#!/usr/bin/env bash

# Theme Persistence Management Script
# Provides utilities for managing Quickshell theme persistence

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell"
THEME_STATE_FILE="$STATE_DIR/user/theme_state.json"
COLORS_FILE="$STATE_DIR/user/generated/colors.json"

show_usage() {
    echo "Theme Persistence Manager"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  status      - Show current theme state"
    echo "  backup      - Create backup of current theme state"
    echo "  restore     - Restore theme from backup"
    echo "  reset       - Reset to default theme"
    echo "  validate    - Validate theme files"
    echo "  debug       - Show debug information"
    echo "  force-save  - Force save current colors to persistent state"
    echo ""
}

show_status() {
    echo "=== Theme Persistence Status ==="
    echo ""
    
    if [ -f "$THEME_STATE_FILE" ]; then
        echo "✅ Persistent theme state: EXISTS"
        echo "📁 Location: $THEME_STATE_FILE"
        echo "📅 Modified: $(stat -c '%y' "$THEME_STATE_FILE")"
        echo "📊 Size: $(stat -c '%s' "$THEME_STATE_FILE") bytes"
        
        if command -v jq >/dev/null 2>&1; then
            echo ""
            echo "🎨 Theme Info:"
            jq -r '.timestamp as $ts | .wallpaperPath as $wp | .darkmode as $dm | "  Timestamp: \($ts | todate)", "  Wallpaper: \($wp)", "  Dark Mode: \($dm)"' "$THEME_STATE_FILE" 2>/dev/null || echo "  Could not parse theme info"
        fi
    else
        echo "❌ Persistent theme state: NOT FOUND"
    fi
    
    echo ""
    
    if [ -f "$COLORS_FILE" ]; then
        echo "✅ Generated colors: EXISTS"
        echo "📁 Location: $COLORS_FILE"
        echo "📅 Modified: $(stat -c '%y' "$COLORS_FILE")"
        echo "📊 Size: $(stat -c '%s' "$COLORS_FILE") bytes"
    else
        echo "❌ Generated colors: NOT FOUND"
    fi
    
    echo ""
    echo "🔧 Quickshell Process:"
    if pgrep -f "quickshell.*ii" >/dev/null 2>&1; then
        echo "✅ Quickshell is running"
        ps aux | grep -E "quickshell.*ii" | grep -v grep | awk '{print "  PID: " $2 ", CPU: " $3 "%, MEM: " $4 "%"}'
    else
        echo "❌ Quickshell is not running"
    fi
}

create_backup() {
    local backup_dir="$STATE_DIR/user/backups"
    local backup_name="theme_backup_$(date +%Y%m%d_%H%M%S)"
    
    mkdir -p "$backup_dir"
    
    echo "Creating theme backup: $backup_name"
    
    if [ -f "$THEME_STATE_FILE" ]; then
        cp "$THEME_STATE_FILE" "$backup_dir/${backup_name}_state.json"
        echo "✅ Backed up persistent theme state"
    fi
    
    if [ -f "$COLORS_FILE" ]; then
        cp "$COLORS_FILE" "$backup_dir/${backup_name}_colors.json"
        echo "✅ Backed up generated colors"
    fi
    
    echo "📁 Backup location: $backup_dir"
    echo "🏷️  Backup name: $backup_name"
}

restore_backup() {
    local backup_dir="$STATE_DIR/user/backups"
    
    if [ ! -d "$backup_dir" ]; then
        echo "❌ No backups directory found"
        return 1
    fi
    
    echo "Available backups:"
    ls -la "$backup_dir" | grep theme_backup | awk '{print "  " $9}' | sort -r
    
    echo ""
    read -p "Enter backup name (without extension): " backup_name
    
    if [ -f "$backup_dir/${backup_name}_state.json" ]; then
        cp "$backup_dir/${backup_name}_state.json" "$THEME_STATE_FILE"
        echo "✅ Restored persistent theme state"
    fi
    
    if [ -f "$backup_dir/${backup_name}_colors.json" ]; then
        cp "$backup_dir/${backup_name}_colors.json" "$COLORS_FILE"
        echo "✅ Restored generated colors"
    fi
    
    echo "🔄 Theme restored. Restart Quickshell to apply changes."
}

reset_theme() {
    echo "⚠️  This will reset theme to defaults. Continue? (y/N)"
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        [ -f "$THEME_STATE_FILE" ] && rm "$THEME_STATE_FILE" && echo "✅ Removed persistent theme state"
        [ -f "$COLORS_FILE" ] && rm "$COLORS_FILE" && echo "✅ Removed generated colors"
        echo "🔄 Theme reset. Restart Quickshell to apply defaults."
    else
        echo "❌ Reset cancelled"
    fi
}

validate_files() {
    echo "=== Theme File Validation ==="
    echo ""
    
    # Validate persistent state
    if [ -f "$THEME_STATE_FILE" ]; then
        echo "🔍 Validating persistent theme state..."
        if jq empty "$THEME_STATE_FILE" 2>/dev/null; then
            echo "✅ Persistent state JSON is valid"
            
            # Check required fields
            local has_version=$(jq -r '.version' "$THEME_STATE_FILE" 2>/dev/null)
            local has_colors=$(jq -r '.colors' "$THEME_STATE_FILE" 2>/dev/null)
            local has_timestamp=$(jq -r '.timestamp' "$THEME_STATE_FILE" 2>/dev/null)
            
            [ "$has_version" != "null" ] && echo "  ✅ Version field present" || echo "  ⚠️  Version field missing"
            [ "$has_colors" != "null" ] && echo "  ✅ Colors field present" || echo "  ❌ Colors field missing"
            [ "$has_timestamp" != "null" ] && echo "  ✅ Timestamp field present" || echo "  ⚠️  Timestamp field missing"
            
        else
            echo "❌ Persistent state JSON is invalid"
        fi
    else
        echo "⚠️  Persistent theme state file not found"
    fi
    
    echo ""
    
    # Validate colors file
    if [ -f "$COLORS_FILE" ]; then
        echo "🔍 Validating generated colors..."
        if jq empty "$COLORS_FILE" 2>/dev/null; then
            echo "✅ Generated colors JSON is valid"
            
            local color_count=$(jq -r 'keys | length' "$COLORS_FILE" 2>/dev/null)
            echo "  🎨 Color count: $color_count"
            
            # Check for essential colors
            local has_background=$(jq -r '.background' "$COLORS_FILE" 2>/dev/null)
            local has_primary=$(jq -r '.primary' "$COLORS_FILE" 2>/dev/null)
            
            [ "$has_background" != "null" ] && echo "  ✅ Background color present" || echo "  ❌ Background color missing"
            [ "$has_primary" != "null" ] && echo "  ✅ Primary color present" || echo "  ❌ Primary color missing"
            
        else
            echo "❌ Generated colors JSON is invalid"
        fi
    else
        echo "⚠️  Generated colors file not found"
    fi
}

show_debug() {
    echo "=== Theme Debug Information ==="
    echo ""
    
    echo "📁 Directory Structure:"
    echo "  State Dir: $STATE_DIR"
    find "$STATE_DIR/user" -name "*.json" -o -name "*.scss" -o -name "*.txt" 2>/dev/null | sort | sed 's/^/  /'
    
    echo ""
    echo "🔗 File Permissions:"
    [ -f "$THEME_STATE_FILE" ] && ls -la "$THEME_STATE_FILE" | sed 's/^/  /'
    [ -f "$COLORS_FILE" ] && ls -la "$COLORS_FILE" | sed 's/^/  /'
    
    echo ""
    echo "💾 Disk Usage:"
    du -sh "$STATE_DIR" 2>/dev/null | sed 's/^/  Total: /'
    du -sh "$STATE_DIR/user/generated" 2>/dev/null | sed 's/^/  Generated: /' || echo "  Generated: N/A"
    
    echo ""
    echo "⚡ Recent Activity:"
    find "$STATE_DIR/user" -name "*.json" -newermt '5 minutes ago' 2>/dev/null | sed 's/^/  Modified: /' || echo "  No recent changes"
    
    echo ""
    echo "🔄 Process Information:"
    ps aux | grep -E "(quickshell|matugen|switchwall)" | grep -v grep | sed 's/^/  /'
}

force_save() {
    echo "🔄 Force saving current colors to persistent state..."
    
    if [ ! -f "$COLORS_FILE" ]; then
        echo "❌ No colors file found to save"
        return 1
    fi
    
    # Create a basic persistent state from current colors
    local timestamp=$(date +%s)000  # JavaScript timestamp format
    local wallpaper_path=$(jq -r '.background.wallpaperPath // ""' "$STATE_DIR/../../.config/illogical-impulse/config.json" 2>/dev/null || echo "")
    
    jq -n \
        --argjson timestamp "$timestamp" \
        --arg wallpaperPath "$wallpaper_path" \
        --argjson colors "$(cat "$COLORS_FILE")" \
        '{
            timestamp: $timestamp,
            colors: $colors,
            darkmode: ($colors.darkmode == "True" or $colors.darkmode == true),
            wallpaperPath: $wallpaperPath,
            version: "1.0"
        }' > "$THEME_STATE_FILE"
    
    echo "✅ Persistent theme state saved"
    echo "📁 Location: $THEME_STATE_FILE"
}

# Main command handling
case "${1:-status}" in
    "status")
        show_status
        ;;
    "backup")
        create_backup
        ;;
    "restore")
        restore_backup
        ;;
    "reset")
        reset_theme
        ;;
    "validate")
        validate_files
        ;;
    "debug")
        show_debug
        ;;
    "force-save")
        force_save
        ;;
    "help"|"-h"|"--help")
        show_usage
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac 