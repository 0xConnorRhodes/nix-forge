{ pkgs, rustToolchain }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "claude-chill";
  version = "0.1.4";

  src = pkgs.fetchFromGitHub {
    owner = "davidbeesley";
    repo = "claude-chill";
    rev = "896e4313216c63e61c46e8495cdb0cb5bfcd550d";
    hash = "sha256-XlYAbtWYGWcn9e4Xj10v07qP6kXknYQQkPFUObR4klA=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [ rustToolchain ];

  buildAndTestSubdir = "crates/claude-chill";

  meta = {
    description = "A command line tool to chill with Claude";
    homepage = "https://github.com/davidbeesley/claude-chill";
    license = pkgs.lib.licenses.mit;
    mainProgram = "claude-chill";
  };
}
