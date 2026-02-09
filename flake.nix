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

    nagih7-dots = {
      url = "git+https://github.com/nagih7/dotfiles?submodules=1";
      flake = false;
    };

    end-4-dots = {
      url = "git+https://github.com/end-4/dots-hyprland?submodules=1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, quickshell, agenix, nagih7-dots, end-4-dots, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Helper to get common args for hosts and home configurations
      getCommonArgs = hostName:
        let
          commonVars = import ./hosts/common/variables.nix;
          hostVars = import ./hosts/${hostName}/variables.nix;
          system = "${commonVars.isa}-${commonVars.os}";
          
          unstable-overlay = final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
        in {
          inherit commonVars hostVars system;
          overlays = [ unstable-overlay ];
          specialArgs = { inherit inputs quickshell commonVars hostVars nagih7-dots end-4-dots; };
        };

      # NixOS System
      mkHost = hostName:
        let
          args = getCommonArgs hostName;
        in
        nixpkgs.lib.nixosSystem {
          system = args.system;
          specialArgs = args.specialArgs;
          modules = [
            ./hosts/${hostName}
            agenix.nixosModules.default
            {
              nixpkgs.overlays = args.overlays;
              nixpkgs.config.allowUnfree = true; 
            }
          ];
        };

      # Home Manager
      mkHome = hostName:
        let
          args = getCommonArgs hostName;
          
          pkgs = import nixpkgs {
            inherit (args) system;
            config.allowUnfree = true;
            config.allowUnfreePredicate = (_: true);
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs; 
          extraSpecialArgs = args.specialArgs;
          
          modules = [
            ./home/${args.hostVars.user.username}
            {
              nixpkgs.overlays = args.overlays;
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop = mkHost "desktop";
        laptop  = mkHost "laptop";
      };

      homeConfigurations = {
        nagih = mkHome "desktop";
        # "nagih" = mkHome "laptop";
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
              nixfmt-rfc-style
            ];
          };
        });
    };
}