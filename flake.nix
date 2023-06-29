{
  description = "A flake for building SUNDIALS for Flint";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;

  inputs.sundials = {
    url = github:LLNL/sundials/v2.7.0;
    flake = false;
  };

  outputs = { self, nixpkgs, sundials }: let

    allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

    forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f (import nixpkgs { inherit system; }));

  in {

    packages = forAllSystems (pkgs: with pkgs; let

      flint-sundials = stdenv.mkDerivation {
        pname = "flint-sundials";
        version = "2.7.0";

        nativeBuildInputs = [ cmake python3 ];

        src = sundials;

        # doCheck = true;

        enableParallelBuilding = true;
      };

    in {

      default = flint-sundials;

    });
  };
}
