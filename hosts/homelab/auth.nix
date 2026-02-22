{ config, ... }:
{
  services.pocket-id = {
    enable = true;
    settings = {
      ANALYTICS_DISABLED = true;
      APP_URL = "https://auth.rishab.org";
      TRUST_PROXY = true;
    };
    environmentFile = config.age.secrets.pocket-id.path;
  };

}
