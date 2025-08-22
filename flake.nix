{
  description = "My NixOS configuration"; # Main flake description

  inputs = {
    # NixOS packages source - using stable 25.05 release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    
    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs"; # Use same nixpkgs as system
    };

    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Hyprland - latest stable
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, quickshell, ... }: {
    nixosConfigurations = {
      # Main system configuration
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Target architecture
        modules = [
          ./configuration.nix # Main system configuration
          
          # Hyprland module
          hyprland.nixosModules.default

          home-manager.nixosModules.home-manager # Home Manager integration
          {
            home-manager.useGlobalPkgs = true;    # Use system's nixpkgs
            home-manager.useUserPackages = true;  # Install packages to user profile
            
            # User-specific configurations
            home-manager.users = {
              nagih = import ./home/nagih.nix; # Main user configuration
            };
            
            # Pass quickshell to home manager
            home-manager.extraSpecialArgs = { 
              inherit quickshell; 
            };
            
            # Backup existing files instead of failing on conflicts
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
  };
}
