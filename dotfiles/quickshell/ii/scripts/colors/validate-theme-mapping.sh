#!/usr/bin/env bash

# Theme Property Mapping Validator
# Helps debug and validate color property assignments

COLORS_FILE="$HOME/.local/state/quickshell/user/generated/colors.json"
APPEARANCE_FILE="$HOME/Workspaces/Config/nixos/home/shared/quickshell/ii/modules/common/Appearance.qml"

echo "=== Theme Property Mapping Validator ==="
echo ""

if [ ! -f "$COLORS_FILE" ]; then
    echo "❌ Colors file not found: $COLORS_FILE"
    exit 1
fi

if [ ! -f "$APPEARANCE_FILE" ]; then
    echo "❌ Appearance file not found: $APPEARANCE_FILE"
    exit 1
fi

echo "📁 Colors file: $COLORS_FILE"
echo "📁 Appearance file: $APPEARANCE_FILE"
echo ""

# Extract all m3 properties from Appearance.qml
echo "🔍 Extracting m3 properties from Appearance.qml..."
m3_properties=$(grep -o 'property color m3[a-zA-Z_]*' "$APPEARANCE_FILE" | sed 's/property color //' | sort)
echo "Found $(echo "$m3_properties" | wc -l) m3 properties"

echo ""
echo "📋 Available m3 properties:"
echo "$m3_properties" | sed 's/^/  /'

echo ""

# Extract all keys from colors.json
echo "🔍 Extracting keys from colors.json..."
if command -v jq >/dev/null 2>&1; then
    color_keys=$(jq -r 'keys[]' "$COLORS_FILE" 2>/dev/null | sort)
    echo "Found $(echo "$color_keys" | wc -l) color keys"
    
    echo ""
    echo "📋 Available color keys:"
    echo "$color_keys" | sed 's/^/  /'
    
    echo ""
    echo "🔄 Mapping analysis:"
    
    while IFS= read -r key; do
        if [ "$key" = "darkmode" ]; then
            echo "  $key -> Appearance.m3colors.darkmode (special case) ✅"
            continue
        fi
        
        # Convert snake_case to camelCase first, then add m3 prefix (lowercase first letter)
        camel_case=$(echo "$key" | sed -r 's/_([a-z])/\U\1/g')
        m3_key="m3${camel_case}"
        
        # Check if this property exists in Appearance.qml
        if echo "$m3_properties" | grep -q "^$m3_key$"; then
            echo "  $key -> $m3_key ✅"
        else
            echo "  $key -> $m3_key ❌ (property not found)"
            
            # Try to find similar properties
            similar=$(echo "$m3_properties" | grep -i "${key:0:5}" | head -3)
            if [ -n "$similar" ]; then
                echo "    Similar properties found:"
                echo "$similar" | sed 's/^/      /'
            fi
        fi
    done <<< "$color_keys"
    
    echo ""
    echo "🔍 Unused m3 properties (no matching color keys):"
    while IFS= read -r m3_prop; do
        # Remove m3 prefix and convert to snake_case
        base_name=$(echo "$m3_prop" | sed 's/^m3//' | sed -r 's/([A-Z])/_\L\1/g' | sed 's/^_//')
        
        if ! echo "$color_keys" | grep -q "^$base_name$"; then
            echo "  $m3_prop (would map from: $base_name)"
        fi
    done <<< "$m3_properties"
    
    echo ""
    echo "📊 Summary:"
    total_keys=$(echo "$color_keys" | wc -l)
    total_props=$(echo "$m3_properties" | wc -l)
    
    mapped_count=0
    while IFS= read -r key; do
        if [ "$key" = "darkmode" ]; then
            ((mapped_count++))
            continue
        fi
        
        camel_case=$(echo "$key" | sed -r 's/_([a-z])/\U\1/g')
        m3_key="m3${camel_case}"
        
        if echo "$m3_properties" | grep -q "^$m3_key$"; then
            ((mapped_count++))
        fi
    done <<< "$color_keys"
    
    echo "  Total color keys: $total_keys"
    echo "  Total m3 properties: $total_props"
    echo "  Successfully mapped: $mapped_count"
    echo "  Mapping success rate: $(( mapped_count * 100 / total_keys ))%"
    
else
    echo "❌ jq not found, cannot analyze color keys"
fi

echo ""
echo "🔧 Recommendations:"
echo "  1. Run this script after each wallpaper change to validate mappings"
echo "  2. Check Quickshell logs for property assignment warnings"
echo "  3. Use theme-persistence.sh to debug theme state"
echo "  4. Consider adding missing properties to Appearance.qml if needed" 