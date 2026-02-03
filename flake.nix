{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, quickshell, agenix, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      mkHost = hostName:
        let
          hostVars = import ./hosts/${hostName}/variables.nix;
          system = "${hostVars.isa}-${hostVars.os}";

          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };

          specialArgs = { inherit inputs quickshell unstable hostVars; };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          
          modules = [
            ./hosts/${hostName}
            agenix.nixosModules.default

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = specialArgs;
                users.${hostVars.user.username} = import ./home/${hostVars.user.username};
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop = mkHost "desktop";
        laptop  = mkHost "laptop";
        # device.example = mkHost "device.example";
      };
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixos-rebuild
              home-manager
              git
              just
            ];
          };
        });
    };
}