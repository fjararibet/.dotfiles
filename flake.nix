{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
    lib = nixpkgs.lib;

  mkHost = {
    hostname,
    system ? "x86_64-linux",
    modules ? [ ],
    specialArgs ? { },
  }:
  lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit inputs;
      nixpkgs-unstable = inputs.nixpkgs-unstable;
    } // specialArgs;

    modules = modules ++ [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs;
        };
        home-manager.users.fjara = import ./home.nix;
      }
      ./hosts/${hostname}/configuration.nix
    ];
  };
  in {
    nixosConfigurations = {
      yunco = mkHost {
        hostname = "yunco";
        modules = [
          inputs.nixos-wsl.nixosModules.default
        ];
      };
      huala = mkHost {
        hostname = "huala";
      };
    };
  };
}
