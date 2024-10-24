#!/bin/sh

hc unrule -F

# MENUS #
#-------#
hc rule title~'launch.sh' floating=on floatplacement=center floating_geometry=600x800
hc rule title~'vsp2' floating=on floatplacement=center floating_geometry=375x1000
hc rule title~'configs' floating=on floatplacement=center floating_geometry=375x600
hc rule title~'windows' floating=on floatplacement=center floating_geometry=700x300
hc rule title~'logout' floating=on floatplacement=center floating_geometry=320x200
hc rule title~'vmach.sh' floating=on floatplacement=center floating_geometry=375x500
hc rule title~'themesel.sh' floating=on floatplacement=center floating_geometry=375x200

# SCRATCHPADS #
#-------------#
hc rule title~'scratchpad' floating=on floatplacement=center floating_geometry=1000x500
hc rule title~'FM' floating=on floatplacement=center floating_geometry=1000x800
hc rule class~'qutebrowser' floating=on floatplacement=center floating_geometry=1800x1000
hc rule title~'Mail' floating=on floatplacement=center floating_geometry=1500x800
hc rule title~'Music' floating=on floatplacement=center floating_geometry=1200x800
hc rule title~'Todo' floating=on floatplacement=center floating_geometry=1000x650

hc rule focus=on # normally focus new clients
hc rule floatplacement=center
#hc rule float_geometry=250x100
#hc rule focus=off # normally do not focus new clients
# give focus to most common terminals
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on floatplacement=center
hc rule windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on floatplacement=smart
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off

hc set tree_style '╾│ ├└╼─┐'

# UNLOCK #
#--------#
hc unlock
