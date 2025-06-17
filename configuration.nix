{ config, pkgs, inputs ? {}, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/system
    ./modules/desktop
  ];
  
  # User accounts
  users.users = {
    nagih = {
      isNormalUser = true;
      description = "Nagih";
      extraGroups = [ "networkmanager" "wheel" "docker" "audio" "video" ];
      shell = pkgs.bash;
    };
  };
  
  # Root user configuration
  users.users.root = {
    hashedPassword = "!"; # Disable root login
  };

  # User groups
  users.groups = {
    docker = {};
  };
  
  # System packages
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    openssh
    htop	# UI monitor
  ];
  
  # Kích hoạt Steam (Neu co su dung steam)
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Mở firewall cho Steam Remote Play
    dedicatedServer.openFirewall = true; # Mở firewall cho Steam dedicated servers
  };
  
  # Unfree nixpkgs
  nixpkgs.config.allowUnfree = true;
  
  # SSH
  programs.ssh.startAgent = true;
  services.openssh.enable = true;
  
  # Mở cổng firewall cho Syncthing
  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];  # GUI và sync
    allowedUDPPorts = [ 22000 21027 ]; # Sync và discovery
  };
    
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}
