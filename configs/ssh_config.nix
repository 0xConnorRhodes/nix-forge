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

      Host media
        Hostname 192.168.86.189
        Port 22
        User media
        SetEnv TERM=xterm-256color
        ProxyJump m

      Host acorn
        Hostname ${secrets.ssh.config.acorn.ip}
        User ${secrets.ssh.config.acorn.user}
        Port ${secrets.ssh.config.acorn.port}
        SetEnv TERM=xterm-256color

      Host tp
        Hostname thinkpad
        Port 22
        User connor
        ServerAliveInterval 60
        ServerAliveCountMax 10
        SetEnv TERM=xterm-256color
        ProxyJump m

      Host ph
        Hostname ${secrets.ssh.config.phone.ip}
        User ${secrets.ssh.config.phone.user}
        Port ${secrets.ssh.config.phone.port}
        SetEnv TERM=xterm-256color
        ProxyJump m
    '';
  };
}
