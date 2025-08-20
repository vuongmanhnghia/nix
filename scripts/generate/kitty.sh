#!/run/current-system/sw/bin/bash

echo "Generating kitty.conf..."

cat > ./generated/kitty.conf << EOF
cursor #dde4e3
cursor_text_color #bec8c8

foreground            #dde4e3
background            #0e1415
selection_foreground  #1b3435
selection_background  #b0cccc
url_color             #80d4d7

# black
color8   #262626
color0   #4c4c4c

# red
color1   #ac8a8c
color9   #c49ea0

# green
color2   #8aac8b
color10  #9ec49f

# yellow
color3   #aca98a
color11  #c4c19e

# blue
color4  #80d4d7
color12 #a39ec4

# magenta
color5   #ac8aac
color13  #c49ec4

# cyan
color6   #8aacab
color14  #9ec3c4

# white
color15   #e7e7e7
color7  #f0f0f0
EOF