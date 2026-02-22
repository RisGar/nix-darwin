{
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        identityAgent = "\"~/Library/Group Containers/group.strongbox.mac.mcguill/agent.sock\"";
      };

      # TODO
      "hostinger" = {
        hostname = "89.117.169.136";
        user = "u797478303";
        port = 65002;
        identityFile = "~/.ssh/hostinger";
        serverAliveInterval = 240;
      };

      "gargnas" = {
        hostname = "gargnas.internal";
        user = "Rishab";
        port = 223;
      };

      "lxhalle" = {
        hostname = "lxhalle.cit.tum.de";
        user = "gargr";
      };

      "proxmox" = {
        hostname = "proxmox.internal";
        user = "root";
      };

      "debian" = {
        hostname = "debian.internal";
        user = "docker";
      };

      "homelab" = {
        hostname = "homelab.internal";
        user = "rishab";
      };

      "valhalla" = {
        hostname = "valhalla.fs.tum.de";
        user = "garg";
      };

      "itsec" = {
        hostname = "sandkasten.sec.in.tum.de";
        user = "team-263";
      };

      "pangolin" = {
        hostname = "85.215.138.48";
        user = "root";
      };
    };
  };
}
