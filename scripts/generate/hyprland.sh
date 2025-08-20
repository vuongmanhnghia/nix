#!/run/current-system/sw/bin/bash

echo "Generating hyprland.conf..."

cat >./generated/hyprland.conf << EOF
# Catppuccin Mocha Theme Colors
\$color0 = rgba(1a1112ff)
\$color1 = rgba(ffb4abff)
\$color2 = rgba(93000aff)
\$color3 = rgba(382e2fff)
\$color4 = rgba(8e4955ff)
\$color5 = rgba(f0dedfff)
\$color6 = rgba(f0dedfff)
\$color7 = rgba(690005ff)
\$color8 = rgba(ffdad6ff)
\$color9 = rgba(561d28ff)
\$color10 = rgba(ffd9ddff)
\$color11 = rgba(3b0714ff)
\$color12 = rgba(72333eff)
\$color13 = rgba(43292dff)
\$color14 = rgba(ffd9ddff)
\$color15 = rgba(2c1518ff)

# Additional theme colors
\$background = rgba(5c3f43ff)
\$foreground = rgba(f0dedfff)
\$cursor = rgba(d7c1c3ff)
\$selection_background = rgba(452b07ff)
\$selection_foreground = rgba(ffddb8ff)
\$color0_alt = rgba(2b1700ff)
\$color1_alt = rgba(5e411cff)
\$color2_alt = rgba(9f8c8eff)
\$color3_alt = rgba(524344ff)
\$color4_alt = rgba(ffb2bcff)
\$color5_alt = rgba(72333eff)
\$color6_alt = rgba(ffd9ddff)
\$color7_alt = rgba(ffb2bcff)
\$color8_alt = rgba(000000ff)
\$color9_alt = rgba(e5bdc1ff)
\$color10_alt = rgba(5c3f43ff)
\$color11_alt = rgba(ffd9ddff)
\$color12_alt = rgba(e5bdc1ff)
\$color13_alt = rgba(000000ff)
\$color14_alt = rgba(fe4070ff)
\$color15_alt = rgba(1a1112ff)

# UI Colors
\$ui_background = rgba(413737ff)
\$ui_foreground = rgba(261d1eff)
\$ui_border = rgba(312828ff)
\$ui_accent = rgba(3d3233ff)
\$ui_accent_alt = rgba(22191aff)
\$ui_shadow = rgba(140c0dff)
\$ui_highlight = rgba(1a1112ff)

# Status colors
\$status_normal = rgba(ffb2bcff)
\$status_warning = rgba(524344ff)
\$status_error = rgba(eabf8fff)
\$status_success = rgba(5e411cff)
\$status_info = rgba(ffddb8ff)
\$status_debug = rgba(eabf8fff)

EOF