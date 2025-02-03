{
  description = "NixOS configuration";

  inputs = {
    slippi.url = "github:lytedev/slippi-nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


    outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    slippi,
    ...
  }: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
#         slippi.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.adam = import ./home.nix;

          home-manager.extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
        }
      ];
    };
  };
}
