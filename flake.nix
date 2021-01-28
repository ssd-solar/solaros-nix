{
  description = "solarOS";

  inputs = {

    /* nix run nixos.nix-prefetch-github -c nix-prefetch-github mkg20001 nixpkgs --rev mkg-patch-a > lib/nixpkgs.json
    nix run nixos.nix-prefetch-github -c nix-prefetch-github mkg20001 nix-node-package --rev master > lib/nix-node-package.json
    nix run nixos.nix-prefetch-github -c nix-prefetch-github nixos nixos-hardware --rev master > lib/nixos-hardware.json
    nix run nixos.nix-prefetch-github -c nix-prefetch-github ssd-solar solarpkg --rev master > lib/solarpkg.json */

    nixpkgs.url = "github:mkg20001/nixpkgs/mkg-patch-a";
    nix-node-package.url = "github:mkg20001/nix-node-package/master";
    nix-node-package.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    # solarpkg.url = "github:ssd-solar/solarpkg/master";
    # solarpkg.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nix-node-package
    , nixos-hardware
    , ...
    } @ inputs:
    let
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      # allSystems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" ];
      allSystems = [ "x86_64-linux" ];

      solarLibOverlay = final: prev: {
        mkNode = nix-node-package.lib.nix-node-package prev;
      };

      solarOverlay = final: prev:
        import ./pkgs prev;

      genericForAllSystems = f: genAttrs allSystems (system: f system);

      forAllSystems = f: genAttrs allSystems (system: f {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            solarLibOverlay
            solarOverlay
          ];
        };
      });
    in
    {
      devShell = forAllSystems ({ system, pkgs, ... }:
        pkgs.mkShell {
          name = "solar-dev";

          # inputsFrom = [ self.packages.${system}.... ];
        });

      packages = forAllSystems
        ({ system, pkgs, ... }:
          import ./pkgs pkgs);

      checks = genericForAllSystems (system: import ./tests (
        f: import "${nixpkgs}/nixos/tests/make-test-python.nix" f { inherit system; }
      ));

      lib = {
        inherit
          forAllSystems
          genericForAllSystems
          nixpkgs;
      };

      # defaultPackage = forAllSystems ({ system, ... }: self.packages.${system}.pijul);
    };
}
