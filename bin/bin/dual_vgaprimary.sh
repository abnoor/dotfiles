#!/bin/sh

xrandr --output VGA1  --mode 1680x1050 --pos 1366x0 --rotate normal --output LVDS1 --mode 1366x768 --pos 0x0 --rotate normal --output DP1 --off --output HDMI1 --off

xrandr --output VGA1 --primary

source ~/.xsessionrc
