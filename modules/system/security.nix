{ config, pkgs, ... }:
{
  # Security configuration
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    
    # Sudo configuration
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };
    
    # PAM configuration
    pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };

  # Enable automatic security updates
  system.autoUpgrade = {
    enable = false; # Set to true if you want automatic updates
    allowReboot = false;
  };
}
