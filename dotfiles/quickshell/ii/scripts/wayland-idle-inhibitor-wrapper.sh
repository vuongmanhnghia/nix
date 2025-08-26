#!/usr/bin/env bash

# Wrapper script for wayland-idle-inhibitor.py
# This ensures the script runs with the correct virtual environment

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_PATH="$HOME/.local/state/quickshell/.venv"

if [ ! -d "$VENV_PATH" ]; then
    echo "Error: Virtual environment not found at $VENV_PATH"
    exit 1
fi

# Activate virtual environment and run the script
source "$VENV_PATH/bin/activate"
exec python3 "$SCRIPT_DIR/wayland-idle-inhibitor.py" "$@"
