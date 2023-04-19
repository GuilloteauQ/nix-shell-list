import subprocess
import json
import argparse
import tempfile
import os

import pathlib
HEREPATH = pathlib.Path(__file__).parent.absolute()

import logging
logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

def build_json(output, flake=None, verbose=False):
    base_command = ["nix-build", f"{HEREPATH}/default.nix", "-o", output]
    if flake:
        base_command += ["--arg", "flake", flake]
    if verbose:
        command_string = " ".join(base_command)
        logging.info(f"Running nix command: {command_string}")
    subprocess.run(base_command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
def show_shells(output, verbose=False):
    with open(output, "r") as json_file:
        json_data = json.load(json_file)
        for system, shells in json_data.items():
            print(f"{system}:")
            for shell_name, shell_deps in shells.items():
                print(f"\t{shell_name}:")
                for dep in shell_deps:
                    name = dep["name"]
                    version = dep["version"] if dep["version"] != "" else "?"
                    print(f"\t\t{name} -> {version}")
    
def main():
    parser = argparse.ArgumentParser(
                    prog='nix-shell-list',
                    description='Shows the versions of the packages in the shells')
    parser.add_argument('-f', '--flake', default=os.getcwd())
    parser.add_argument('-v', '--verbose', action='store_true')

    args = parser.parse_args()
    flake = args.flake
    verbose = args.verbose
    
    outputdir = tempfile.TemporaryDirectory()
    output = f"{outputdir.name}/shells.json"
    
    if verbose:
        logging.info(f"Output will be stored in {output}")
    
    build_json(output, flake, verbose)
    
    show_shells(output, verbose)
    return 0

if __name__ == "__main__":
    main()
