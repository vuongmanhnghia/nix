{ hostVars, ... }:

{
  config = {
    services.cloudflared = hostVars.cloudflared;
  };
}