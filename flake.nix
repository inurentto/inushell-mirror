{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, nixpkgs, flake-parts } @ inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    perSystem = { config, pkgs, ... }: {
      packages = rec {
        inu-shell = pkgs.callPackage ./. {};
        debug = inu-shell.override { debug = true; };
        default = inu-shell;
      };
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.packages.default config.packages.default.plugin ];
        packages = [ config.packages.debug ];
      };
    };

    systems = [ "x86_64-linux" ];
  };
}