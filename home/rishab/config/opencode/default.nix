{
  config,
  lib,
  ocrtool-mcp,
  pkgs,
  ...
}:
{

  programs.mcp = {
    enable = true;
    servers = {
      tavily = {
        url = "https://mcp.tavily.com/mcp/?tavilyApiKey={env:TAVILY_API_KEY}";
      };
      ocrtool = {
        command = lib.getExe ocrtool-mcp.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
      things = {
        command = lib.getExe' config.programs.uv.package "uvx";
        args = [ "things-mcp" ];
      };

    };
  };

  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    settings = builtins.fromJSON <| builtins.readFile ./opencode.json;
  };

  # Context7
  xdg.configFile."opencode/AGENTS.md".source = ./AGENTS.md;
  home.file.".agents/skills/find-docs/SKILL.md".source = ./skills/find-docs.md;

  services.ollama = {
    enable = true;
  };

}
