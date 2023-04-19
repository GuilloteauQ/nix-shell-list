# nix-shell-list

Prints the version of each package used in the different `devShells` of a Nix flake

## Usage

Print the packages versions for the flake in the current directory:

```sh
nix run github:GuilloteauQ/nix-shell-list
```


Print the packages versions for any flake:

```sh
nix run github:GuilloteauQ/nix-shell-list -- -f github:GuilloteauQ/qornflakes
```
  
Output:  

```
x86_64-linux:
        check:
        shell-R:
                R -> 4.2.1
                r-tidyverse -> 1.3.2
                r-zoo -> 1.8-11
                r-reshape2 -> 1.4.4
        shell-julia:
                julia-bin -> 1.8.3
        shell-lua:
                lua -> 5.4.4
        shell-python:
                python3 -> 3.8.15
```

## Add to registries

```sh
nix registry add nsl github:GuilloteauQ/nix-shell-list
```

and now you can call from `nsl`:


```sh
nix run nsl
# OR
nix run nsl -- -f github:GuilloteauQ/qornflakes
```
