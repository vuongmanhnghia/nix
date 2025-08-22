{
  description = "My NixOS configuration";

  inputs = {
    # NixOS packages source - using stable 25.05 release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    
    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Hyprland - latest stable
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, quickshell, ... }:
  let
    system = "x86_64-linux";
    
    # Create a special args set với tất cả inputs
    specialArgs = {
      inherit quickshell;
      inputs = { inherit nixpkgs home-manager hyprland quickshell; };
    };
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        
        modules = [
          # Pass inputs to configuration.nix
          ({ config, pkgs, ... }: {
            _module.args = specialArgs;
          })
          
          ./configuration.nix
          
          # Hyprland module
          hyprland.nixosModules.default

          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            
            # Pass inputs to Home Manager
            home-manager.extraSpecialArgs = specialArgs;
            
            home-manager.users = {
              nagih = import ./home/nagih.nix;
            };
          }
        ];
      };
    };
    
    # Optional: Provide development shell
    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
      buildInputs = with nixpkgs.legacyPackages.${system}; [
        nixos-rebuild
        home-manager
      ];
    };
  };
}