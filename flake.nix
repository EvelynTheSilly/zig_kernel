{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnsupportedSystem = true;
      };

      cross = pkgs.pkgsCross.aarch64-embedded;
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          cross.buildPackages.gcc
          cross.buildPackages.binutils
          pkgs.qemu
          pkgs.cmake
          pkgs.mask
        ];

        shellHook = ''
          echo "AArch64 bare-metal dev shell ready!"
          echo "Toolchain prefix: aarch64-none-elf-"
        '';
      };
    });
}
