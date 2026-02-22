{ ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /export          *(rw,fsid=0,no_subtree_check,crossmnt,insecure)
      /export/external *(rw,nohide,insecure,no_subtree_check)
    '';
  };

  networking.firewall.allowedTCPPorts = [
    2049 # nfsv4
  ];

}
