{ config, lib, pkgs, ... }:
{
  services.openiscsi = {
    enable = true;  # Enable openiscsi daemon
    name = "iqn.2024-09.com.nixos:my-nixos-initiator";  # Set **YOUR** iSCSI initiator name not the one that you are trying to connect to. I am pretty sure this can be whatever you want.

    discoverPortal = "192.168.0.11";   # IP of your iscsi server
    extraConfig = ''
      node.startup = automatic
      node.session.auth.authmethod = none
      #node.session.auth.authmethod = CHAP
      #node.session.auth.username = storageiscsi
      #node.session.auth.password = jbVJyRsamDb6CMz5
    '';
  };

  systemd.services.iscsi-login-nasdata = {
    description = "Login to iSCSI target iqn.2004-04.com.qnap:ts-464:iscsi.storage.82de6a";
    after = [ "network.target" "iscsid.service" ];
    wants = [ "iscsid.service" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p 192.168.0.11";
      ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2004-04.com.qnap:ts-464:iscsi.storage.82de6a -p 192.168.0.11 --login";
      ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2004-04.com.qnap:ts-464:iscsi.storage.82de6a -p 192.168.0.11 --logout";
      Restart = "on-failure";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };
}
