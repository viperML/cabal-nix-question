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
        pkgs: { myShell = pkgs.mkShell { packages = [ pkgs.cabal-install ]; }; }
      );
    };
}
