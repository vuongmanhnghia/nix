{ config, pkgs, ... }:

{
  programs.systemPackages = with pkgs; [
    docker-compose
    tailscale
  ];

  # === DOCKER CONFIGURATION ===
  virtualisation.docker = {
    enable = true;        # Enable Docker containerization platform
    # Automatic cleanup to prevent disk space issues
    autoPrune = {
      enable = true;      # Enable automatic cleanup of unused Docker resources
      dates = "weekly";   # Run cleanup weekly
    };
  };

  # === USER PERMISSIONS ===
  users.users.nagih.extraGroups = [ "docker" ];  # Add user to docker group for container management
}