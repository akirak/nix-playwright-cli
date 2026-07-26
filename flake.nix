{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});

      inherit (nixpkgs) lib;

      npmDepsHash = lib.trim (builtins.readFile ./npm-hash.txt);
    in
    {
      packages = eachSystem (pkgs: {
        default = pkgs.callPackage ./package.nix {
          inherit npmDepsHash;
        };

        firefox = pkgs.callPackage ./package.nix {
          inherit npmDepsHash;
          browserName = "firefox";
        };
      });

      devShells = eachSystem (pkgs: {
        # A Nix shell for running the update script.
        #
        # Example: `nix develop .#ci -c ./update.bash`
        ci = pkgs.mkShell {
          packages = [
            pkgs.prefetch-npm-deps
          ];
        };
      });
    };
}
