{
  description = "netty flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.bashInteractive
            pkgs.autoconf
            pkgs.automake
            pkgs.libtool
            pkgs.gnumake
            pkgs.cmake
            pkgs.ninja
            pkgs.cargo
            pkgs.gnutar
            pkgs.gcc
            pkgs.git
            pkgs.jdk25
            pkgs.libaio
            pkgs.openssl
            pkgs.apr
            pkgs.lksctp-tools
          ];
          hardeningDisable = [ "all" ];
        };
      }
    );
}
