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

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, quickshell, agenix, ... }:
  let
    vars = import ./vars.nix;
    pkgs = nixpkgs.legacyPackages."${vars.isa}-${vars.os}";

    unstable = import nixpkgs-unstable {
      system = "${vars.isa}-${vars.os}";
      config.allowUnfree = true;
    };
    
    specialArgs = {
      inherit quickshell unstable vars;
      inputs = { inherit nixpkgs nixpkgs-unstable home-manager quickshell agenix vars; };
    };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      system = "${vars.isa}-${vars.os}";
    
      modules = [
        ./configuration.nix
        agenix.nixosModules.default 

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = specialArgs;
            users.${vars.user.username} = import ./home/user.nix;
          };
        }
      ];
    };
    
    devShells."${vars.isa}-${vars.os}".default = pkgs.mkShell {
      buildInputs = with pkgs; [
        nixos-rebuild
        home-manager
      ];
    };
  };
}