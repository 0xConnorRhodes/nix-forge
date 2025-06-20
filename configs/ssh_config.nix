{ config, pkgs, secrets, ... }:
{
  home-manager.users.${config.myConfig.username} = {
    home.file.".ssh/config".text = ''
      Host s
        Hostname ${secrets.ssh.config.pve.ip}
        Port ${secrets.ssh.config.pve.port}
        User ${secrets.ssh.config.pve.user}
        ServerAliveInterval 60
        ServerAliveCountMax 10
        SetEnv TERM=xterm-256color

      Host m
        Hostname ${secrets.ssh.config.mpro.ip}
        Port ${secrets.ssh.config.mpro.port}
        User ${secrets.ssh.config.mpro.user}
        ServerAliveInterval 60
        ServerAliveCountMax 10
        SetEnv TERM=xterm-256color

      Host lat
        Hostname ${secrets.ssh.config.latitude.ip}
        Port ${secrets.ssh.config.latitude.port}
        User ${secrets.ssh.config.latitude.user}
        SetEnv TERM=xterm-256color
        ProxyJump m

      Host ph
        Hostname ${secrets.ssh.config.phone.ip}
        User ${secrets.ssh.config.phone.user}
        Port ${secrets.ssh.config.phone.port}
        SetEnv TERM=xterm-256color
    '';
  };
}
