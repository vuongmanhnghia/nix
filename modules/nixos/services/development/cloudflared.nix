{ config, pkgs, hostVars, ... }:

{
  services.cloudflared = hostVars.cloudflared;
}