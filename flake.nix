{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        packages = let
          mk-script = lambdananas:
            import ./wrapper_script.nix { inherit pkgs lambdananas; };
        in rec {
          default = hcs;
          lambdananas = pkgs.callPackage ./lambdananas.nix { };
          lambdananas-glibc = lambdananas.override { withGlibc = true; };

          hcs = mk-script lambdananas;
          hcs-glibc = mk-script lambdananas-glibc;
        };
      });
}
