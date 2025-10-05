{ config, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    docker-compose    # Multi-container Docker orchestration
    virtualbox        # Virtualization software for running virtual machines
    vagrant           # Development environment manager
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
}