{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    sddm-wallpaper = {
      url = "file:///home/stephen/Downloads/best-laptop-wallpaper.png";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      plasma-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        asus-vivobook = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;

            ## found from https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [ ./nixos/configuration.nix ];
        };
      };

      homeConfigurations = {
        "stephen@asus-vivobook" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home.nix
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
        };
      };
    };
}
