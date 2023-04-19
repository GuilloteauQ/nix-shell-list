{ pkgs ? import <nixpkgs> { }
  # (fetchTarball {
  #   url = "https://github.com/NixOS/nixpkgs/archive/22.11.tar.gz";
  #   sha256 = "sha256:11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";
  # })
  # { }
, flake ? ./.
}:

let
  flake_str = builtins.toString flake;
in

pkgs.writeTextFile {
  name = "shells.json";
  text =
    (
      builtins.toJSON
        (
          builtins.mapAttrs
            (system: shellset: # for all the system
              builtins.mapAttrs
                (shellname: shellder: # for all shells
                  # parse the derivation name
                  builtins.map (pname: builtins.parseDrvName pname)
                    # Get the name of the packages
                    (builtins.map (package: package.name)
                      # Packages in the shell
                      ((if builtins.hasAttr "buildInputs" shellder then shellder.buildInputs else [ ]) ++ (if builtins.hasAttr "nativeBuildInputs" shellder then shellder.nativeBuildInputs else [ ]))
                    )
                )
                shellset
            )
            ((builtins.getFlake flake_str).outputs.devShells))
    );
}
  
