{ config, pkgs, ... }:

{
  # Warp Terminal
  home.file = {
    ".local/share/warp-terminal/launch_configurations" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Workspaces/config/nixos/workflow/warp-terminal";
      recursive = true;
    };
  };
}
