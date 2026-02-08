{ config, pkgs, ... }:
let
  hazelnut = import ../../pkgs/rust/hazelnut {
    inherit pkgs;
    rustToolchain = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" ];
    };
  };
in
{
  systemd.user.services."hazelnutd" = {
    description = "Hazelnut File Organizer Daemon";
    after = [ "default.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "${hazelnut}/bin/hazelnutd run";
      Restart = "on-failure";
      RestartSec = 5;
      Type = "simple";
    };
  };
}
