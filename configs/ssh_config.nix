{ config, secrets, ... }:

let
  sopsFile = ./../secrets.yaml;
in
{
  sops.secrets."ssh/mainframe/ip" = { inherit sopsFile; };
  sops.secrets."ssh/mainframe/port" = { inherit sopsFile; };
  sops.secrets."ssh/mainframe/user" = { inherit sopsFile; };
  sops.secrets."ssh/mainframe/et_port" = { inherit sopsFile; };
  sops.secrets."ssh/freeside/ip" = { inherit sopsFile; };
  sops.secrets."ssh/freeside/port" = { inherit sopsFile; };
  sops.secrets."ssh/freeside/user" = { inherit sopsFile; };
  sops.secrets."ssh/lib/ip" = { inherit sopsFile; };
  sops.secrets."ssh/lib/port" = { inherit sopsFile; };
  sops.secrets."ssh/lib/user" = { inherit sopsFile; };
  sops.secrets."ssh/forgejo/port" = { inherit sopsFile; };
  sops.secrets."ssh/forgejo/user" = { inherit sopsFile; };

  sops.templates."ssh_config" = {
    content = ''
      Host git.connorrhodes.com
        Port ${config.sops.placeholder."ssh/forgejo/port"}
        User ${config.sops.placeholder."ssh/forgejo/user"}

      Host m
        Hostname ${config.sops.placeholder."ssh/mainframe/ip"}
        Port ${config.sops.placeholder."ssh/mainframe/port"}
        User ${config.sops.placeholder."ssh/mainframe/user"}
        ServerAliveInterval 60
        ServerAliveCountMax 10
        SetEnv TERM=xterm-256color

      Host media
        Hostname 192.168.86.189
        Port 22
        User media
        SetEnv TERM=xterm-256color
        ProxyJump m

      Host tp
        Hostname thinkpad
        Port 22
        User connor
        ServerAliveInterval 60
        ServerAliveCountMax 10
        SetEnv TERM=xterm-256color
        ProxyJump m

      Host freeside
        Hostname ${config.sops.placeholder."ssh/freeside/ip"}
        Port ${config.sops.placeholder."ssh/freeside/port"}
        User ${config.sops.placeholder."ssh/freeside/user"}
        SetEnv TERM=xterm-256color
        ProxyJump m

      Host lib
        Hostname ${config.sops.placeholder."ssh/lib/ip"}
        Port ${config.sops.placeholder."ssh/lib/port"}
        User ${config.sops.placeholder."ssh/lib/user"}
        SetEnv TERM=xterm-256color
        ProxyJump m
    '';
    path = "${config.home.homeDirectory}/.ssh/config";
  };

  sops.templates."ssh_aliases" = {
    content = ''
      alias mm='et -p ${config.sops.placeholder."ssh/mainframe/et_port"} m'
      alias ml='et -p ${config.sops.placeholder."ssh/mainframe/et_port"} m -c "et ${config.sops.placeholder."ssh/lib/user"}@${config.sops.placeholder."ssh/lib/ip"}"'
    '';
    path = "${config.home.homeDirectory}/.config/sops/ssh_aliases.sh";
  };
}
