let
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFEZBe4EhYSeInjCVp/GKmPjlsCRivRBCqyjuMYPhu35 root@nixos";
  vps = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDW4UtgtG3e+OefLelfGbltJLgO3PJBbdY41nyE9ttg3 root@noob-vmag";
in
{
  # Encrypt this file for both the user and the server
  "./secrets/cloudflared.age".publicKeys = [ desktop vps ];
}