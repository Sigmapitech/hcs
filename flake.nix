{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";

    lambdananas-src = {
      url = "github:Epitech/lambdananas/v2.4.3.2";
      flake = false;
    };
  };

  outputs = { self, lambdananas-src, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        packages = rec {
          default = hcs;
          lambdananas = pkgs.haskell.lib.buildStackProject {
            name = "lambdananas";
            src = lambdananas-src;
            version = "v2.4.3.2";

            buildInputs = [ pkgs.haskell.compiler.integer-simple.ghc884 ];
          };

          hcs = import ./wrapper_script.nix { inherit pkgs lambdananas; };
        };
      });
}
