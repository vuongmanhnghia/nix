{
  description = "My NixOS configuration";

  inputs = {
    # NixOS packages source - using stable 25.11 release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, quickshell, agenix, ... }:
  let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";

    unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    
    # Create a special args set với tất cả inputs
    specialArgs = {
      inherit quickshell unstable;
      inputs = { inherit nixpkgs nixpkgs-unstable home-manager quickshell agenix; };
    };
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          # Pass inputs to configuration.nix
          ({ config, pkgs, ... }: {
            _module.args = specialArgs;
          })
          
          ./configuration.nix

          agenix.nixosModules.default 

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
    devShells."x86_64-linux".default = pkgs.mkShell {
      buildInputs = with pkgs; [
        nixos-rebuild
        home-manager
      ];
    };
  };
}