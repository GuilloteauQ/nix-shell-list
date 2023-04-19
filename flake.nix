{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      apps.${system} = rec{
        default = nsl;
        nsl = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nsl";
        };
      };
      packages.${system} = rec {
        default = nix-shell-list;
        nix-shell-list = pkgs.python3Packages.buildPythonPackage rec {
          name = "nix-shell-list";
          version = "0.0.1";
          src = ./.;
          propagatedBuildInputs = with (pkgs.python3Packages); [
          ];
          doCheck = false;
        };      
      };
      devShells.${system}.default = with pkgs;
        mkShell {
          buildInputs = [ python3 ];
        };
    };
}
