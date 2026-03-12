{ pkgs, rustToolchain }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "rtk";
  version = "0.29.0";

  src = pkgs.fetchFromGitHub {
    owner = "rtk-ai";
    repo = "rtk";
    rev = "v${version}";
    hash = "sha256-QGHCa8rO4YBFXdrz78FhWKFxY7DmRxCXM8iYQv4yTYE=";
  };

  cargoHash = "sha256-gNJjtQah7NFSgFVYJftK19dECzDvLCi2E33na2PtKmc=";

  doCheck = false;

  nativeBuildInputs = [ rustToolchain ];

  meta = {
    description = "Token-optimized CLI proxy for LLM development workflows";
    homepage = "https://github.com/rtk-ai/rtk";
    license = pkgs.lib.licenses.mit;
    mainProgram = "rtk";
  };
}
