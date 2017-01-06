#!/bin/sh

xrandr --output HDMI-1 --mode 1920x1080 --pos 1366x0 --rotate normal --output LVDS-1 --mode 1366x768 --pos 0x0 --rotate normal --output DP-1 --off --output VGA-1 --off

xrandr --output HDMI-1 --primary

source ~/.xsessionrc
