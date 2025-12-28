{ config, pkgs, ... }:

let
  tunnelID = "5f129b60-0c24-4fd4-9cbd-0b42657d59f7";
  domain = "nooblearn2code.com";
  file = ../../secrets/cloudflared.age;
  # owner = "cloudflared";
  # group = "cloudflared";
  owner = "root";
  mode = "440";
in
{
  age.secrets.cloudflared = {
    file = file;
    owner = owner;
    # group = group;
    mode = mode;
  };

  # 1. Enable the service
  services.cloudflared = {
    enable = true;
    tunnels = {
      "${tunnelID}" = {
        credentialsFile = config.age.secrets.cloudflared.path;     

        # Default behavior for unmatched requests
        default = "http_status:404";
        
        # Ingress Rules (The "Router" for your tunnel)
        ingress = {
          "portainer.${domain}" = {
            service = "https://localhost:9443";
            originRequest = {
              # Required if Portainer uses self-signed certs
              noTLSVerify = true; 
            };
          };

          # "ssh.${domain}" = {
          #   service = "ssh://localhost:22";
          # };
          
          # "whoami.${domain}" = {
          #   service = "http://localhost:8080";
          # };
        };
      };
    };
  };

  # systemd.services."cloudflared-tunnel-${tunnelID}".serviceConfig = {
  #   # limit resource usage
  #   LimitNOFILE = 1048576;
  #   # Systemd hardening options
  #   ProtectSystem = "strict";
  #   ProtectHome = true;
  #   PrivateTmp = true;
  #   PrivateDevices = true;
  #   ProtectKernelTunables = true;
  #   ProtectControlGroups = true;
  #   RestrictSUIDSGID = true;
  #   # If your credentials are in /run/secrets, you might need to bind mount or allow access
  # };
}