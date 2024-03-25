{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        apps = rec {
          default = nsl;
          nsl = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/nsl";
          };
        };
        packages = rec {
          default = nix-shell-list;
          nix-shell-list = pkgs.python3Packages.buildPythonPackage rec {
            name = "nix-shell-list";
            version = "0.0.1";
            src = ./.;
            propagatedBuildInputs = with (pkgs.python3Packages); [ ];
            doCheck = false;
          };
        };
        devShells.default = with pkgs; mkShell { buildInputs = [ python3 ]; };
      });
}
