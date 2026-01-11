{ lib, secrets, ... }:

{
  services.sshwifty = {
    enable = true;

    settings = {
      HostName = "";
      SharedKey = "";
      DialTimeout = 5;
      Socks5 = "";
      Socks5User = "";
      Socks5Password = "";
      Hooks = {
        before_connecting = [ ];
      };
      HookTimeout = 30;
      Servers = [
        {
          ListenInterface = "127.0.0.1";
          ListenPort = 36135;
          InitialTimeout = 10;
          ReadTimeout = 120;
          WriteTimeout = 120;
          HeartbeatTimeout = 15;
          ReadDelay = 10;
          WriteDelay = 10;
          TLSCertificateFile = "";
          TLSCertificateKeyFile = "";
          ServerMessage = "";
        }
      ];
      Presets = [
        {
          Title = "mpro";
          Type = "SSH";
          Host = "127.0.0.1:31583";
          TabColor = "2E7D32";
          Meta = {
            User = "connor";
            Encoding = "utf-8";
            Authentication = "Private Key";
            Fingerprint = secrets.sshwifty.fingerprint;
          } // {
            "Private Key" = lib.replaceStrings ["\\n"] ["\n"] secrets.sshwifty.privateKey;
          };
        }
      ];
      OnlyAllowPresetRemotes = true;
    };
  };
}
