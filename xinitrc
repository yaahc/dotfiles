#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run window managers from here)
#

# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

sh ~/.fehbg &
#DISPLAY=:0.0 feh --bg-scale "$(find ~/.wallpaper/*|shuf -n1)"
#random_wallpaper & 
compton -b
unclutter &

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"
exec bspwm-session
#sxhkd &
#exec bspwm -s "$PANEL_FIFO" -p W 2> ~/.bspwm.log
