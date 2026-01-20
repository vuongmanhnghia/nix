{ config, pkgs, vars, ... }:

{
  services.cloudflared = vars.cloudflared;
}