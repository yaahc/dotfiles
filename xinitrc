#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run window managers from here)
#

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# exec i3 -V >> ~/.i3/i3log 2>&1
xset +fp /usr/share/fonts/local
xset fp rehash

sh ~/.fehbg &
dropboxd &
#DISPLAY=:0.0 feh --bg-scale "$(find ~/.wallpaper/*|shuf -n1)"
#random_wallpaper & 
xrdb ~/.Xresources
compton -b

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"
sxhkd &
exec bspwm -s "$PANEL_FIFO" -p W 2> ~/.bspwm.log

#exec i3
