{
  inputs = {
    nix-alien.url = "github:thiagokokada/nix-alien";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-24-11.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-cli.url = "github:nix-community/nixos-cli";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    inputactions = {
      url = "github:taj-ny/InputActions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      # nixpkgs-24-11,
      home-manager,
      plasma-manager,
      nix-alien,
      nixos-cli,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        asus-vivobook = nixpkgs.lib.nixosSystem {

          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
            # pkgs-24-11 = import nixpkgs-24-11 {
            #   system = "x86_64-linux";
            #   config.allowUnfree = true;
            # };
          };
          modules = [
            ./nixos/configuration.nix
            nixos-cli.nixosModules.nixos-cli
          ];
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
