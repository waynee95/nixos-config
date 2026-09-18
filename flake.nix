{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      commonModules = [
        {
          nixpkgs.overlays = [
            (final: prev: {
              hotkeyhub = final.callPackage ./pkgs/hotkeyhub.nix { };
            })
          ];
        }

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.waynee95 = import ./modules/home;

          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    in
    {
      nixosConfigurations = {
        thinkpad_X230 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

          modules = commonModules ++ [
            ./hosts/thinkpad_X230/configuration.nix
          ];
        };

        workstation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

          modules = commonModules ++ [
            ./hosts/workstation/configuration.nix
          ];
        };
      };
    };
}
