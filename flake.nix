{
  description = "jj-lsp";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        # nixpkgs' Rust instead of rust-toolchain.toml: fenix fetches the
        # toolchain manifest during evaluation, so evaluating this package for
        # another platform needs a builder for that platform.
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "jj-lsp";
          version = "0.1.1-dev1";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
          doCheck = true;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cargo
            clippy
            rust-analyzer
            rustc
            rustfmt
          ];
        };
      });
}
