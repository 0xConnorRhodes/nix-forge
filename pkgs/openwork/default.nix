{ pkgs, opencode }:

let
  version = "0.11.202";

  src = pkgs.fetchurl {
    url = "https://github.com/different-ai/openwork/releases/download/v${version}/openwork-desktop-linux-amd64.deb";
    hash = "sha256-QaF/vRPeCjB5tFkh3iKnKBzK2GeP+tzvaY31EM6AlFg=";
  };

  extracted = pkgs.stdenv.mkDerivation {
    name = "openwork-extracted-${version}";
    inherit src;

    nativeBuildInputs = [ pkgs.dpkg ];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    installPhase = ''
      mkdir -p $out
      cp -r usr/. $out/
    '';

    dontFixup = true;
  };

in
pkgs.stdenv.mkDerivation rec {
  pname = "openwork";
  inherit version;

  src = extracted;

  nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeBinaryWrapper ];

  buildInputs = with pkgs; [
    gtk3
    gdk-pixbuf
    cairo
    glib
    webkitgtk_4_1
    libsoup_3
    libgcc
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/openwork/sidecars $out/share

    cp ${src}/bin/OpenWork-Dev $out/lib/openwork/
    chmod +x $out/lib/openwork/OpenWork-Dev

    cp ${src}/bin/openwork-server $out/lib/openwork/sidecars/
    cp ${src}/bin/openwork-orchestrator $out/lib/openwork/sidecars/
    cp ${src}/bin/opencode-router $out/lib/openwork/sidecars/
    cp ${src}/bin/chrome-devtools-mcp $out/lib/openwork/sidecars/
    cp ${src}/bin/versions.json $out/lib/openwork/sidecars/
    cp ${opencode}/bin/opencode $out/lib/openwork/sidecars/opencode

    chmod +x $out/lib/openwork/sidecars/*

    cp -r ${src}/share/icons $out/share/
    cp -r ${src}/share/applications $out/share/

    makeBinaryWrapper $out/lib/openwork/OpenWork-Dev $out/bin/openwork \
      --prefix PATH : $out/lib/openwork/sidecars \
      --set-default WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  postFixup = ''
    cp ${src}/bin/openwork-server $out/lib/openwork/sidecars/openwork-server
    cp ${src}/bin/openwork-orchestrator $out/lib/openwork/sidecars/openwork-orchestrator
    cp ${src}/bin/opencode-router $out/lib/openwork/sidecars/opencode-router
    cp ${src}/bin/chrome-devtools-mcp $out/lib/openwork/sidecars/chrome-devtools-mcp
    chmod +x $out/lib/openwork/sidecars/openwork-server $out/lib/openwork/sidecars/openwork-orchestrator $out/lib/openwork/sidecars/opencode-router $out/lib/openwork/sidecars/chrome-devtools-mcp
  '';

  meta = {
    description = "Open-source alternative to Claude Cowork, powered by opencode";
    homepage = "https://github.com/different-ai/openwork";
    license = pkgs.lib.licenses.mit;
    mainProgram = "openwork";
    platforms = [ "x86_64-linux" ];
  };
}
