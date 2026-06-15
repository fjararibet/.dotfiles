{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-wsl, ... }:
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
          inherit nixpkgs-unstable;
        } // specialArgs;

        modules = modules ++ [
          ./hosts/${hostname}/configuration.nix
        ];
      };
  in {
    nixosConfigurations = {
      yunco = mkHost {
        hostname = "yunco";
        modules = [
          nixos-wsl.nixosModules.default
        ];
      };
      huala = mkHost {
        hostname = "huala";
      };
    };
  };
}
