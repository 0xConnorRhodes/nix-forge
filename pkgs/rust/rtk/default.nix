{ pkgs, rustToolchain, src }:

pkgs.rustPlatform.buildRustPackage {
  pname = "rtk";
  version = (builtins.fromTOML (builtins.readFile "${src}/Cargo.toml")).package.version;

  inherit src;

  cargoLock.lockFile = "${src}/Cargo.lock";

  doCheck = false;

  nativeBuildInputs = [ rustToolchain ];

  meta = {
    description = "Token-optimized CLI proxy for LLM development workflows";
    homepage = "https://github.com/rtk-ai/rtk";
    license = pkgs.lib.licenses.mit;
    mainProgram = "rtk";
  };
}
