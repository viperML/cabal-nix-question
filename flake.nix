{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system: function nixpkgs.legacyPackages.${system}
        );
    in
    {
      packages = forAllSystems (pkgs: { myPkg = pkgs.haskellPackages.developPackage { root = ./.; }; });

      devShells = forAllSystems (
        pkgs: {
          myShell = pkgs.mkShell {
            packages = [ pkgs.cabal-install ];
            # you need `ghc` inside your devshell, and that `ghc` should have a pkgdb created by nix with all your transitive dependencies
            inputsFrom = [ self.outputs.packages.myPkg ];
          };
        }
      );
    };
}
