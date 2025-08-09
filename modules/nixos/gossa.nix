{ config, pkgs, pkgsUnstable, inputs, secrets, ... }:

{
  environment.systemPackages = [ pkgs.gossa ];

  # systemd.services.gossa-files = {
  #   enable = true;
  #   serviceConfig = {
  #     ExecStart = "${pkgs.gossa}/bin/gossa -p 8782 /mnt/zfiles/";
  #     Restart = "always";
  #     User = config.myConfig.username;
  #     Group = "users";
  #   };
  #   wantedBy = [ "multi-user.target" ];
  # };

  systemd.services.gossa-papers = {
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.gossa}/bin/gossa -p 8783 /home/connor/Documents/papers/";
      Restart = "always";
      User = config.myConfig.username;
      Group = "users";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.gossa-vark = {
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.gossa}/bin/gossa -p 8781 /mnt/zmedia/videos/archive/";
      Restart = "always";
      User = config.myConfig.username;
      Group = "users";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
