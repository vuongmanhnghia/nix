#!/usr/bin/env bash

# Color
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

writer() {
    local text="$1"
    local delay="${2:-0.00}"
    local no_newline="$3"

    [[ -z "$text" ]] && return

    local decoded_text
    decoded_text=$(printf "%b" "$text")

    for (( i=0; i<${#decoded_text}; i++ )); do
        local char="${decoded_text:$i:1}"

        if [[ "$char" == $'\n' ]]; then
            printf "\n" >&2
        else
            printf "%s" "$char" >&2
        fi
        
        sleep "$delay"
    done

    [[ -z "$no_newline" ]] && printf "\n" >&2
}

ask() {
    local prompt_text="$1"
    local default_value="$2"
    local user_input

    printf "${CYAN}?? ${NC}" >&2
    writer "${prompt_text} ${YELLOW}[Default: ${default_value}]${NC}: " 0.01 "true"

    read user_input < /dev/tty
    echo "${user_input:-$default_value}"
}

# === Main Script ===
clear
cat << 'EOF'
███╗   ██╗██╗██╗  ██╗    ██╗  ██╗    ███╗   ██╗ █████╗  ██████╗ ██╗██╗  ██╗
████╗  ██║██║╚██╗██╔╝    ╚██╗██╔╝    ████╗  ██║██╔══██╗██╔════╝ ██║██║  ██║
██╔██╗ ██║██║ ╚███╔╝       ███╔╝     ██╔██╗ ██║███████║██║  ███╗██║███████║
██║╚██╗██║██║ ██╔██╗      ██╔██╗     ██║╚██╗██║██╔══██║██║   ██║██║██╔══██║
██║ ╚████║██║██╔╝ ██╗    ██╔╝ ██╗    ██║ ╚████║██║  ██║╚██████╔╝██║██║  ██║
╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝    ╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═╝  ╚═╝
===========================================================================
EOF
printf "${GREEN}" >&2
writer "\nHi there!" 0.01
writer "Welcome to the NixOS configuration by Nagih [https://github.com/nagih7]" 0.01

printf "${YELLOW}" >&2
writer "\nPlease answer the following questions..."
printf "${NC}" >&2

writer "\n--- System Configuration ---\n" 0.01
HOSTNAME=$(ask "Enter your desired hostname" "example-host")
CPU=$(./scripts/detect_cpu.sh)
GPU=$(./scripts/detect_gpu.sh)
ENABLE_FIREWALL=$(ask "Do you want to enable the firewall? (yes/no)" "no")
if [ "$ENABLE_FIREWALL" == "yes" ]; then
    ENABLE_FIREWALL="true"
    FIREWALL_PORTS=$(ask "Enter the ports to open (comma-separated)" "80,443")
else
    ENABLE_FIREWALL="false"
    FIREWALL_PORTS=""
fi

writer "\nUser configuration ---\n" 0.01
USERNAME=$(ask "Enter your name (Join)" "none")
USER_DESCRIPTION=$(ask "Enter a description for you (Join Smith)" "$USERNAME")
USER_EMAIL=$(ask "Enter your email (your_email@example.com)" "your_email@example.com")

writer "\nGit configuration ---\n" 0.01
GIT_NAME=$(ask "Enter your Git name" "$USERNAME")
GIT_EMAIL=$(ask "Enter your Git email" "$USER_EMAIL")

writer "\nMore configuration ---\n" 0.01
ENABLE_TAILSCALE=$(ask "Do you want to enable Tailscale? (yes/no)" "no")
if [ "$ENABLE_TAILSCALE" == "yes" ]; then
    ENABLE_TAILSCALE="true"
else
    ENABLE_TAILSCALE="false"
fi
ENABLE_SYNCTHING=$(ask "Do you want to enable Syncthing? (yes/no)" "no")
if [ "$ENABLE_SYNCTHING" == "yes" ]; then
    ENABLE_SYNCTHING="true"
else
    ENABLE_SYNCTHING="false"
fi


printf "${GREEN}\nThank you! The setup script will now proceed with your configuration.${NC}\n" >&2
writer ". . . . . . . . . ." 0.1

printf "${BLUE}" >&2
writer "\nYour configuration summary:" 0.01
printf "${GREEN}" >&2
writer "Hostname:           ${HOSTNAME}" 0.01
writer "CPU:                ${CPU}" 0.01
writer "GPU:                ${GPU:-None}" 0.01
writer "Firewall Enabled:   ${ENABLE_FIREWALL} ${FIREWALL_PORTS}" 0.01
writer "Tailscale Enabled:  ${ENABLE_TAILSCALE}" 0.01
writer "User Name:          ${USERNAME}" 0.01
writer "User Description:   ${USER_DESCRIPTION}" 0.01
writer "User Email:         ${USER_EMAIL}" 0.01
writer "Git Name:           ${GIT_NAME}" 0.01
writer "Git Email:          ${GIT_EMAIL}" 0.01
writer "Syncthing Enabled:  ${ENABLE_SYNCTHING}" 0.01

printf "\n\n${NC}" >&2
CONFIRMED=$(ask "Do you confirm the above configuration? (yes/no)" "yes")
if [ "$CONFIRMED" != "yes" ]; then
    printf "${RED}\nConfiguration not confirmed. Exiting setup.${NC}\n" >&2
    exit 1
fi
writer ". . . . . . . . . ." 0.1


rm -rf hosts/{desktop,laptop,${HOSTNAME}}
rm -rf home/{nagih,${USERNAME}}

# === Generate Configuration Files ===
mkdir -p hosts/${HOSTNAME}

# /hosts/${HOSTNAME}/default.nix
cat > hosts/${HOSTNAME}/default.nix <<EOL
{ hostVars, ... }:

{
  imports = [
    ./hardware-configuration.nix # Hardware configurations
    ../common
  ];
}
EOL

# /hosts/${HOSTNAME}/hardware-configuration.nix
cat /etc/nixos/hardware-configuration.nix > hosts/${HOSTNAME}/hardware-configuration.nix

# /hosts/${HOSTNAME}/variables.nix
cat > hosts/${HOSTNAME}/variables.nix <<EOL
rec {
  nix_config = "$(pwd)";

  hostname = "${HOSTNAME}";
  cpu = "${CPU}";
  gpu = "${GPU}";
  nameservers = [ "8.8.8.8" "8.8.4.4" ];
  firewall = {
    enable = ${ENABLE_FIREWALL};
    tcp_ports = [ ${FIREWALL_PORTS//,/ } ];
    udp_ports = [ ];
    trusted_interfaces = [ "tailscale0" ];
  };
  fallback_dns = [ "1.1.1.1" "1.0.0.1" ];

  user = {
    name = "${USERNAME}";
    username = "$(whoami)";
    description = "${USER_DESCRIPTION}";
    email = "${USER_EMAIL}";
  };

  git_name = "${GIT_NAME}";
  git_email = "${GIT_EMAIL}";

  tailscale = { enable = ${ENABLE_TAILSCALE}; };
  syncthing = { enable = ${ENABLE_SYNCTHING}; };
}
EOL

# === Generate user configuration file ===
mkdir -p home/$(whoami)
cat > home/$(whoami)/default.nix <<EOL
{ config, pkgs, unstable, hostVars, ... }:

{ 
  imports = [
    ../common
  ];

  home.packages = with pkgs; [
    unstable.brave                    
    unstable.discord                  
    unstable.spotify                  
    unstable.vscode                   
  ];

  home.shellAliases = { };
}

EOL

# Commit changes
git add hosts/${HOSTNAME}/*
git add home/$(whoami)/*
git commit -m "Setup configuration for host: ${HOSTNAME}"

printf "${GREEN}\nSetup completed successfully!${NC}\n" >&2

writer "Please review the generated configuration files in the 'hosts/${HOSTNAME}/' and 'home/$(whoami)/' directories."

writer "You can now proceed with deploying your NixOS configuration."
writer "\nRun: ${YELLOW}sudo nixos-rebuild switch --flake .#${HOSTNAME}${NC}"