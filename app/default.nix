{ pkgs ? import <nixpkgs> {}
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
      builtins.toJSON (
        builtins.mapAttrs
          (system: shellset: # for all the system
            builtins.mapAttrs
              (shellname: shellder:
                builtins.map (pname: builtins.parseDrvName pname)
                  (builtins.map (package: package.name) shellder.buildInputs)
              )
              shellset
          )
          ((builtins.getFlake flake_str).outputs.devShells)));
}
  
