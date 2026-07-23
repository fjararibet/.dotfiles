{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-sway-working.url = "github:NixOS/nixpkgs/f3d24765175719ad0e816a3d5dcb8e84c11bd842";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
    ttyp = {
      url = "github:fjararibet/ttyp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      lib = nixpkgs.lib;

      paths = {
        config = ./config;
        home = ./home;
        modules = ./modules;
      };

   unstableOverlay = final: _prev: {
     unstable = import nixpkgs-unstable {
       inherit (final) config;
       inherit (final.stdenv.hostPlatform) system;
     };
   };

   ttypOverlay = inputs.ttyp.overlays.default;

      mkHomeConfig =
        {
          system ? "x86_64-linux",
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
       overlays = [ unstableOverlay ttypOverlay ];
          };

          extraSpecialArgs = {
            inherit inputs paths;
            nixpkgs-unstable = inputs.nixpkgs-unstable;
          };

          modules = modules;
        };

      mkHost =
        {
          hostname,
          system ? "x86_64-linux",
          modules ? [ ],
          specialArgs ? { },
        }:
        lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs paths;
            nixpkgs-unstable = inputs.nixpkgs-unstable;
          }
          // specialArgs;

          modules = modules ++ [
            {
        nixpkgs.overlays = [ unstableOverlay ttypOverlay ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs paths;
                nixpkgs-unstable = inputs.nixpkgs-unstable;
              };
              home-manager.users.fjara = import ./hosts/${hostname}/home.nix;
            }
            ./hosts/${hostname}/configuration.nix
          ];
        };
    in
    {
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

      homeManagerModules.default = ./home/common.nix;
      homeModules.default = ./home/common.nix;

      homeConfigurations = {
        fjara = mkHomeConfig {
          modules = [ ./home/common.nix ];
        };
        yunco = mkHomeConfig {
          modules = [ ./hosts/yunco/home.nix ];
        };
        huala = mkHomeConfig {
          modules = [ ./hosts/huala/home.nix ];
        };
      };
    };
}
