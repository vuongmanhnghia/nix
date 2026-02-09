{
  config,
  pkgs,
  lib,
  nagih7-dots,
  ...
}:

{
  # === WEZTERM TERMINAL CONFIGURATION ===
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # === ENVIRONMENT AND DEFAULT TERMINAL SETUP ===
  home.sessionVariables = {
    TERMINAL = "wezterm";
    TERM = "wezterm";
  };

  # === FILE ASSOCIATIONS ===
  xdg.mimeApps.defaultApplications = {
    "application/x-terminal" = "org.wezfurlong.wezterm.desktop";
    "x-scheme-handler/terminal" = "org.wezfurlong.wezterm.desktop";
  };

  # === FONTS FOR WEZTERM (minimal to avoid conflicts) ===
  home.packages = with pkgs; [
    nerd-fonts.inconsolata
  ];

  # === FILE COPYING ===
  xdg.configFile."wezterm".source = "${nagih7-dots}/wezterm";

  # === DESKTOP INTEGRATION ===
  xdg.desktopEntries."wezterm-here" = {
    name = "WezTerm Here";
    comment = "Open WezTerm in current directory";
    exec = "wezterm start --cwd %f";
    icon = "org.wezfurlong.wezterm";
    type = "Application";
    categories = [
      "System"
      "TerminalEmulator"
    ];
  };
}
