#!/usr/bin/env bash

arch=$(uname -m)

cpu_vendor_raw=$(grep -m 1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
cpu_model_raw=$(grep -m 1 'Model' /proc/cpuinfo | cut -d: -f2 | xargs)

if [[ "$arch" == "x86_64" ]]; then
    if [[ "$cpu_vendor_raw" == "GenuineIntel" ]]; then
        echo "intel"
    elif [[ "$cpu_vendor_raw" == "AuthenticAMD" ]]; then
        echo "amd"
    fi
elif [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
    if [[ "$cpu_model_raw" == *"Raspberry Pi"* ]]; then
        echo "raspberry_pi"
    else
        echo "arm_generic"
    fi
else
    echo "unknown_arch"
fi