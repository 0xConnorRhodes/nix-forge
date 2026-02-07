{ pkgs, rustToolchain }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "hazelnut";
  version = "0.2.39";

  src = pkgs.fetchFromGitHub {
    owner = "ricardodantas";
    repo = "hazelnut";
    rev = "v${version}";
    hash = "sha256-YEcRw/oq47Jtaq0V87WzgwJskkVVCgIYrz1rqqdheiA=";
  };

  cargoHash = "sha256-Vb2c9CCVwW1pYBcWUHM9mrtE8Gk1jNVQSjy3P8rot7Y=";

  nativeBuildInputs = [ rustToolchain ];

  meta = {
    description = "A command line tool to organize your notes in a tree structure";
    homepage = "https://github.com/ricardodantas/hazelnut";
    license = pkgs.lib.licenses.gpl3Only;
    mainProgram = "hazelnut";
  };
}
