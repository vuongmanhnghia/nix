#!/run/current-system/sw/bin/bash

echo "Generating waybar.css..."

cat > ./generated/waybar.css << EOF
/*
* Css Colors
* Generated with Matugen
*/

@define-color background #0e1415;

@define-color error #ffb4ab;

@define-color error_container #93000a;

@define-color inverse_on_surface #2b3232;

@define-color inverse_primary #00696c;

@define-color inverse_surface #dde4e3;

@define-color on_background #dde4e3;

@define-color on_error #690005;

@define-color on_error_container #ffdad6;

@define-color on_primary #003738;

@define-color on_primary_container #9cf1f3;

@define-color on_primary_fixed #002021;

@define-color on_primary_fixed_variant #004f51;

@define-color on_secondary #1b3435;

@define-color on_secondary_container #cce8e8;

@define-color on_secondary_fixed #041f20;

@define-color on_secondary_fixed_variant #324b4c;

@define-color on_surface #dde4e3;

@define-color on_surface_variant #bec8c8;

@define-color on_tertiary #1e314c;

@define-color on_tertiary_container #d5e3ff;

@define-color on_tertiary_fixed #061c36;

@define-color on_tertiary_fixed_variant #354763;

@define-color outline #899393;

@define-color outline_variant #3f4949;

@define-color primary #80d4d7;

@define-color primary_container #004f51;

@define-color primary_fixed #9cf1f3;

@define-color primary_fixed_dim #80d4d7;

@define-color scrim #000000;

@define-color secondary #b0cccc;

@define-color secondary_container #324b4c;

@define-color secondary_fixed #cce8e8;

@define-color secondary_fixed_dim #b0cccc;

@define-color shadow #000000;

@define-color source_color #a7b3b3;

@define-color surface #0e1415;

@define-color surface_bright #343a3a;

@define-color surface_container #1a2121;

@define-color surface_container_high #252b2b;

@define-color surface_container_highest #303636;

@define-color surface_container_low #161d1d;

@define-color surface_container_lowest #090f0f;

@define-color surface_dim #0e1415;

@define-color surface_tint #80d4d7;

@define-color surface_variant #3f4949;

@define-color tertiary #b4c7e9;

@define-color tertiary_container #354763;

@define-color tertiary_fixed #d5e3ff;

@define-color tertiary_fixed_dim #b4c7e9;
EOF