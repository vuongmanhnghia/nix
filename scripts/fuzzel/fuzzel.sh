#!/run/current-system/sw/bin/bash

# Fuzzel launcher

# Check if fuzzel is running
if ! pgrep -x "fuzzel" > /dev/null; then
    fuzzel
else
    pkill fuzzel
fi
