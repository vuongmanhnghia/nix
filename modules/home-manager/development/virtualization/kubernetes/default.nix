{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kubectl
    cilium-cli
  ];
}
