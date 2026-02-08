#!/usr/bin/env bash

gpu_list=$(lspci -nn | grep -Ei "vga|3d|display" | tr '[:upper:]' '[:lower:]')

if echo "$gpu_list" | grep -q "nvidia"; then
    echo "nvidia"
elif echo "$gpu_list" | grep -qE "amd|radeon"; then
    echo "amdgpu"
else
    echo ""
fi