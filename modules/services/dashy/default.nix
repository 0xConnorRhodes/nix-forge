{ config, pkgs, pkgsUnstable, inputs, secrets, ... }:

{
  services.dashy = {
    enable = true;
    settings = import ./config.nix;
  };

  # create custom symlink to static dashy files (config.services.dashy.finalDrv) so they can be served with caddy
  home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
    home.stateVersion = "24.11";
    imports = [
      {
        home.file.".config/dashy-link" = {
          # The source is the path you want to link to.
          # We get it directly from your NixOS system configuration.
          source = config.services.dashy.finalDrv;

          # The target is where the symlink will be created.
          # This will create a symlink at: ~/.config/dashy-link
          # You can change the target path to whatever you like, e.g., "dashy" for ~/dashy
          target = ".local/share/dashy";
        };
      }
    ];
  };
}
