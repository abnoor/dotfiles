#!/bin/bash
#
# volume - dzen volume bar
#

#Customize this stuff
IF="Master"         # audio channel: Master|PCM
SECS="1"            # sleep $SECS
BG="#151515"        # background colour of window
FG="#eeeeee"        # foreground colour of text/icon
BAR_FG="#808080"    # foreground colour of volume bar
BAR_BG="#090909"    # background colour of volume bar
XPOS="515"          # horizontal positioning
YPOS="700"          # vertical positioning
HEIGHT="30"         # window height
WIDTH="250"         # window width
BAR_WIDTH="180"     # width of volume bar
ICON=~/.icons/xbm8x8/spkr_04.xbm
FONT="-*-clean-*-*-*-*-*-*-*-*-*-*-*-*"
ICON_VOL=~/.icons/xbm8x8/spkr_04.xbm
ICON_VOL_MUTE=~/.icons/xbm8x8/spkr_02.xbm
ICON=$ICON_VOL

#Probably do not customize
PIPE="/tmp/dvolpipe"

err() {
  echo "$1"
  exit 1
}

usage() {
  echo "usage: dvol [option] [argument]"
  echo
  echo "Options:"
  echo "     -i, --increase - increase volume by \`argument'"
  echo "     -d, --decrease - decrease volume by \`argument'"
  echo "     -t, --toggle   - toggle mute on and off"
  echo "     -h, --help     - display this"
  exit 
}   
    
#Argument Parsing
case "$1" in 
  '-i'|'--increase')
    [ -z "$2" ] && err "No argument specified for increase."
    [ -n "$(tr -d [0-9] <<<$2)" ] && err "The argument needs to be an integer."
    AMIXARG="${2}%+"
    ;;
  '-d'|'--decrease')
    [ -z "$2" ] && err "No argument specified for decrease."
    [ -n "$(tr -d [0-9] <<<$2)" ] && err "The argument needs to be an integer."
    AMIXARG="${2}%-"
    ;;
  '-t'|'--toggle')
    AMIXARG="toggle"
    ;;
  ''|'-h'|'--help')
    usage
    ;;
  *)
    err "Unrecognized option \`$1', see dvol --help"
    ;;
esac

#Actual volume changing (readability low)
AMIXOUT="$(amixer set "$IF" "$AMIXARG" | tail -n 1)"
MUTE="$(cut -d '[' -f 4 <<<"$AMIXOUT")"
VOL="$(cut -d '[' -f 2 <<<"$AMIXOUT" | sed 's/%.*//g')"
if [ "$MUTE" = "off]" ]; then
  ICON=$ICON_VOL_MUTE
else
  ICON=$ICON_VOL
fi

#Using named pipe to determine whether previous call still exists
#Also prevents multiple volume bar instances
if [ ! -e "$PIPE" ]; then
  mkfifo "$PIPE"
  (dzen2 -tw "$WIDTH" -h "$HEIGHT" -x "$XPOS" -y "$YPOS" -fn "$FONT" -bg "$BG" -fg "$FG" < "$PIPE"
   rm -f "$PIPE") &
fi

#Feed the pipe!
(echo "$VOL" | gdbar -l "^i(${ICON})" -fg "$BAR_FG" -bg "$BAR_BG" -w "$BAR_WIDTH" ; sleep "$SECS") > "$PIPE"
