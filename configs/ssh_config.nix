{ config, pkgs, secrets, ... }:
{
  home-manager.users.${config.myConfig.username} = {
    home.file.".ssh/config".text = ''
      Host m
        Hostname ${secrets.ssh.config.mpro.ip}
        Port ${secrets.ssh.config.mpro.port}
        User ${secrets.ssh.config.mpro.user}
        ServerAliveInterval 60
        ServerAliveCountMax 10
        SetEnv TERM=xterm-256color

      Host acorn
        Hostname ${secrets.ssh.config.acorn.ip}
        User ${secrets.ssh.config.acorn.user}
        Port ${secrets.ssh.config.acorn.port}
        SetEnv TERM=xterm-256color

      Host s
        Hostname ${secrets.ssh.config.pve.ip}
        Port ${secrets.ssh.config.pve.port}
        User ${secrets.ssh.config.pve.user}
        ServerAliveInterval 60
        ServerAliveCountMax 10
        SetEnv TERM=xterm-256color

      Host ph
        Hostname ${secrets.ssh.config.phone.ip}
        User ${secrets.ssh.config.phone.user}
        Port ${secrets.ssh.config.phone.port}
        SetEnv TERM=xterm-256color
    '';
  };
}
