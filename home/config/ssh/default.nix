{
  config,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      # "${config.xdg.configHome}/colima/ssh_config"
    ];
    matchBlocks = {
      "*" = {
        identityAgent = "\"~/Library/Group Containers/group.strongbox.mac.mcguill/agent.sock\"";
      };

      "gargnas" = {
        hostname = "192.168.178.85";
        user = "Rishab";
        port = 223;
      };

      "hostinger" = {
        hostname = "89.117.169.136";
        user = "u797478303";
        port = 65002;
        identityFile = "~/.ssh/hostinger";
        serverAliveInterval = 240;
      };

      "lxhalle" = {
        hostname = "lxhalle.cit.tum.de";
        user = "gargr";
      };

      "proxmox" = {
        hostname = "192.168.178.25";
        user = "root";
      };

      "debian-docker" = {
        hostname = "192.168.178.28";
        user = "docker";
      };

      "valhalla" = {
        hostname = "valhalla.fs.tum.de";
        user = "garg";
      };

      "itsec" = {
        hostname = "sandkasten.sec.in.tum.de";
        user = "team-263";
      };
    };
  };
}
