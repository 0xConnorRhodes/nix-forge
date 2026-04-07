{ pkgs, bun, src }:

let
  version = (builtins.fromJSON (builtins.readFile "${src}/apps/cli/package.json")).version;

  targetMap = {
    "x86_64-linux" = "bun-linux-x64";
    "aarch64-linux" = "bun-linux-arm64";
    "x86_64-darwin" = "bun-darwin-x64";
    "aarch64-darwin" = "bun-darwin-arm64";
  };

  outputMap = {
    "x86_64-linux" = "btca-linux-x64";
    "aarch64-linux" = "btca-linux-arm64";
    "x86_64-darwin" = "btca-darwin-x64";
    "aarch64-darwin" = "btca-darwin-arm64";
  };

  buildTarget = targetMap.${pkgs.stdenv.hostPlatform.system}
    or (throw "btca: unsupported system ${pkgs.stdenv.hostPlatform.system}");

  outputName = outputMap.${pkgs.stdenv.hostPlatform.system}
    or (throw "btca: unsupported system ${pkgs.stdenv.hostPlatform.system}");

  # FOD: build from source (has network access for bun install)
  # patchelf strips store references so FOD output is valid
  btca-unwrapped = pkgs.stdenv.mkDerivation {
    name = "btca-unwrapped-${version}";
    inherit src;

    nativeBuildInputs = [ bun pkgs.patchelf ];

    buildPhase = ''
      HOME=$TMPDIR
      ${bun}/bin/bun install
      (cd apps/cli && BTCA_TARGETS=${buildTarget} ${bun}/bin/bun run scripts/build-binaries.ts)
    '';

    installPhase = ''
      mkdir -p $out
      cp apps/cli/dist/${outputName} $out/btca
      cp apps/cli/dist/tree-sitter-worker.js $out/
      cp apps/cli/dist/tree-sitter.js $out/
      cp apps/cli/dist/tree-sitter.wasm $out/
      # Strip nix store references from binary so FOD is valid
      # nix-ld provides the dynamic linker at runtime
      patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 $out/btca || true
      patchelf --remove-rpath $out/btca || true
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-1IIjwer4l4Rrs/3+i0dgdS7sBkBSOBZ/lVEeWMTGPyI=";
  };

in
# Wrap with env vars (regular derivation, no FOD restrictions)
pkgs.runCommand "btca-${version}" {
  nativeBuildInputs = [ pkgs.makeWrapper ];
  meta = {
    description = "CLI tool for asking questions about technologies using source code";
    homepage = "https://github.com/davis7dotsh/better-context";
    license = pkgs.lib.licenses.mit;
    mainProgram = "btca";
    platforms = builtins.attrNames targetMap;
  };
} ''
  mkdir -p $out/bin $out/lib/btca
  install -m755 ${btca-unwrapped}/btca $out/bin/btca
  cp ${btca-unwrapped}/tree-sitter-worker.js $out/lib/btca/
  cp ${btca-unwrapped}/tree-sitter.js $out/lib/btca/
  cp ${btca-unwrapped}/tree-sitter.wasm $out/lib/btca/
  wrapProgram $out/bin/btca \
    --set OTUI_TREE_SITTER_WORKER_PATH $out/lib/btca/tree-sitter-worker.js
''
