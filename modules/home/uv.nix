{ inputs, config, pkgs, ... }:

let
  # Generate uv completions once at build time
  uvCompletions = pkgs.runCommand "uv-completions" {
    buildInputs = [ pkgs.uv ];
  } ''
    mkdir -p $out/share/zsh/site-functions
    ${pkgs.uv}/bin/uv generate-shell-completion zsh > $out/share/zsh/site-functions/_uv
  '';
in
{
  programs.uv = {
    enable = true;
    settings = {
      python-downloads = "automatic";
      python-preference = "managed";
    };
  };

  # set global default python version
  # equivalent to uv python pin --global <version>
  home.file.".config/uv/.python-version".text = "3.12";

  # Add uv shell completions to zsh by sourcing pre-generated completion file
  programs.zsh.initContent = ''
    source ${uvCompletions}/share/zsh/site-functions/_uv
  '';
}
