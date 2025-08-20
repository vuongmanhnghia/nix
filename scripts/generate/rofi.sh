#!/run/current-system/sw/bin/bash

echo "Generating rofi.rasi..."

cat > ./generated/rofi.rasi << EOF
* {
    primary: #80d4d7; 
    primary-fixed: #9cf1f3; 
    primary-fixed-dim: #80d4d7; 
    on-primary: #003738; 
    on-primary-fixed: #002021; 
    on-primary-fixed-variant: #004f51; 
    primary-container: #004f51; 
    on-primary-container: #9cf1f3; 
    secondary: #b0cccc; 
    secondary-fixed: #cce8e8; 
    secondary-fixed-dim: #b0cccc; 
    on-secondary: #1b3435; 
    on-secondary-fixed: #041f20; 
    on-secondary-fixed-variant: #324b4c; 
    secondary-container: #324b4c; 
    on-secondary-container: #cce8e8; 
    tertiary: #b4c7e9; 
    tertiary-fixed: #d5e3ff; 
    tertiary-fixed-dim: #b4c7e9; 
    on-tertiary: #1e314c; 
    on-tertiary-fixed: #061c36; 
    on-tertiary-fixed-variant: #354763; 
    tertiary-container: #354763; 
    on-tertiary-container: #d5e3ff; 
    error: #ffb4ab; 
    on-error: #690005; 
    error-container: #93000a; 
    on-error-container: #ffdad6; 
    surface: #0e1415; 
    on-surface: #dde4e3; 
    on-surface-variant: #bec8c8; 
    outline: #899393; 
    outline-variant: #3f4949; 
    shadow: #000000; 
    scrim: #000000; 
    inverse-surface: #dde4e3; 
    inverse-on-surface: #2b3232; 
    inverse-primary: #00696c; 
    surface-dim: #0e1415; 
    surface-bright: #343a3a; 
    surface-container-lowest: #090f0f; 
    surface-container-low: #161d1d; 
    surface-container: #1a2121; 
    surface-container-high: #252b2b; 
    surface-container-highest: #303636; 
}
EOF