{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";

    lambdananas-src = {
      url = "git+ssh://git@github.com/Epitech/lambdananas";
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
            version = "2.0.0";

            buildInputs = [ pkgs.haskell.compiler.integer-simple.ghc884 ];
          };

          hcs = import ./wrapper_script.nix { inherit pkgs lambdananas; };
        };
      });
}
