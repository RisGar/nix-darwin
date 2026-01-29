{ ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /export          192.168.178.0/24(rw,fsid=0,no_subtree_check,crossmnt,insecure)
      /export/external 192.168.178.0/24(rw,nohide,insecure,no_subtree_check)
    '';
  };

  networking.firewall.allowedTCPPorts = [
    2049 # nfsv4
  ];

}
