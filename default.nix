let
  nixpkgs = import ./nixpkgs.nix;
  serverPackages = nixpkgs.haskellPackages;
  clientPackages = nixpkgs.haskell.packages.ghcjs;
  server = serverPackages.callCabal2nix "server" ./server {
    common = serverPackages.callCabal2nix "common" ./common {};
  };
  client = clientPackages.callCabal2nix "client" ./client {
    common = clientPackages.callCabal2nix "common" ./common {};
  };
in
  { inherit client server; }
