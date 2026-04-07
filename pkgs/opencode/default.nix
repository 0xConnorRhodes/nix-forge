{ pkgs, pkgsUnstable, bun }:

# Override opencode to use baseline bun so the compiled binary
# doesn't require AVX instructions (needed for older CPUs like Nehalem)
pkgsUnstable.opencode.override {
  inherit bun;
}
