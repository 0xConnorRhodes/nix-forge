{ config, pkgs, pkgsUnstable, inputs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgsUnstable.ollama;
    acceleration = false; # CPU only
  };
}
