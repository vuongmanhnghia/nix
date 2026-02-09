{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # === MODERN CLI REPLACEMENTS ===
    eza # Modern ls replacement with better formatting
    speedtest-cli # Internet speed test command line interface
    nodePackages.vercel # Vercel CLI
  ];
}
