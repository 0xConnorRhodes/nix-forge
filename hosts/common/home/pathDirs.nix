{ pkgs }:
{
  extraPaths = [
    "$HOME/.local/bin"
    "$HOME/code/scripts/bin"
    "$HOME/code/scripts/priv/bin"
    "$HOME/.bun/bin"
    "$HOME/code/scripts/work/bin"
    "$HOME/code/scripts/pkm"
    "$HOME/.cargo/bin"
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    "/opt/homebrew/bin"
  ];
}
