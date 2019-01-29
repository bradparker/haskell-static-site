let
  nixpkgs = import ./nixpkgs.nix;
  default = import ./default.nix;
  serverEnvAttrs = default.server.env.drvAttrs;
  clientEnvAttrs = default.client.env.drvAttrs;

  merged = serverEnvAttrs // {
    name = "haskell-static-site-dev-env";
    nativeBuildInputs =
      serverEnvAttrs.nativeBuildInputs ++
      clientEnvAttrs.nativeBuildInputs;
  };
in
  nixpkgs.stdenv.mkDerivation merged
