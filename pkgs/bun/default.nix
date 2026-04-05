{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "bun";
  version = "1.3.11";

  src = pkgs.fetchurl {
    url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
    hash = "sha256-q+NG9jQUVHzfazW3pkmkkMcouT0AYiYVaSORioTA5Zs=";
  };

  nativeBuildInputs = [ pkgs.unzip pkgs.autoPatchelfHook ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 bun $out/bin/bun
    ln -s $out/bin/bun $out/bin/bunx
  '';

  meta = {
    description = "Bun JavaScript runtime (baseline build for older CPUs)";
    homepage = "https://bun.sh";
    mainProgram = "bun";
  };
}
