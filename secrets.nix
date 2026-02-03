let
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFEZBe4EhYSeInjCVp/GKmPjlsCRivRBCqyjuMYPhu35 root@nixos";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUCM/D+Bs76aQSFBPQ6ls2mLOp29PllJ1kb0CY5VRsw root@nixos";
  # device.example = "ssh-ed25519 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx root@example";

in
{
  # Encrypt this file for both the user and the server
  "./secrets/cloudflared.age".publicKeys = [ desktop laptop ];
}