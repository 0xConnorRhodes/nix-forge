{ pkgs, stdenv, bundlerEnv, ruby }:
let
  gems = bundlerEnv {
    inherit ruby;
    gemdir  = ./.;
  };
in stdenv.mkDerivation {
  src = ./.;
  buildInputs = [gems ruby];
  installPhase = ''
    mkdir -p $out
    cp -r $src $out
  '';
}
