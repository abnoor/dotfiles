#!/bin/sh

#source ~/bin/source.sh
open="^fg(#262626)^i("$ICONDIR"/side_l.xbm)^fg()^bg(#262626)"
close="^fg(#1a1a1a)^i("$ICONDIR"/side_l.xbm)^fg()^bg()"
sep="^fg($GRAY)^i("$ICONDIR"/seperator.xbm)^fg()"
arrow="^i("$ICONDIR"/arrow_r_single.xbm)"

#MUSIC() {
    #if [[ -z $(ncmpcpp --now-playing) ]]; then
        #return
    #else
        #artist=$(ncmpcpp --now-playing %a)
        #song=$(ncmpcpp --now-playing %t)
    #fi
    
    #headphones="^i("$ICONDIR"/headphones.xbm)"
    #echo "^fg($L_CYAN)$headphones^fg() $artist ^fg($GRAY)$song ^fg($RED)$arrow^fg($L_CYAN)$arrow^fg($GRAY)$arrow^fg()"
#}

VOLUME() {
    level=$(amixer get Master | sed -n "6p" | awk '{gsub(/[]%[]/,"");print$5}')
    volbar=$(echo "$level" | dzen2-gdbar -h '8' -w '48' -s o -ss '1' -sw '2' -bg "#333333" -fg "$WHITE" -max '101')
    speaker="^i("$ICONDIR"/speaker.xbm)"
    echo "^fg($L_CYAN)$speaker^fg() $volbar"
}

#BATTERY() {
    #level=$(acpi | awk '{gsub(/[%,]/,"");print$4}')
    #battbar=$(echo "$level" | gdbar -h '8' -w '48' -s o -ss 1 -sw 2 -bg '#333333' -fg "$WHITE" -max '101')
    #battery="^i("$ICONDIR"/battery.xbm)"
    #echo "^fg($L_CYAN)$battery^fg() $battbar"
#}

TIME() {
    time=$(date +%I:%M)
    month=$(date +%b)
    day=$(date +%d)
    clock="^i("$ICONDIR"/clock.xbm)"
    calender="^i("$ICONDIR"/calender.xbm)"
    echo "^fg($L_CYAN)$calender ^fg($YELLOW)$month ^fg($L_YELLOW)$day ^fg($L_CYAN)$clock^fg() ^fg($L_RED)$time^fg()"
}

#WEATHER() {
    #current_cond=$(curl -s http://forecast.weather.gov/MapClick.php\?CityName\=Galway\&state\=NY\&site\=ALY\&lat\=43.0188\&lon\=-74.0318\#.Utc7IJAhu00 | grep "Current" | awk -F 'myforecast-current' '{print$2}' | sed -e 's|</p>||g' -e 's|<p||g' -e 's|class="||g' -e 's|">||g' -e '/^$/d')
    #current_temp=$(curl -s http://forecast.weather.gov/MapClick.php\?CityName\=Galway\&state\=NY\&site\=ALY\&lat\=43.0188\&lon\=-74.0318\#.Utc7IJAhu00 | grep "Current" | awk -F 'myforecast-current-lrg' '{print$2}' | awk '{print$1}' | sed -e 's|</p><p><span||g' -e 's|">||g' -e 's|&deg;F||g' -e '/^$/d' )

    #shopt -s nocasematch
    ##current_cond="snow" 
    #if [[ $current_cond == *cloud* || $current_cond == *overcast* ]]; then
            #icon="^i("$ICONDIR"/cloud.xbm)"
    #elif [[ $current_cond == *rain* ]]; then
            #icon="^i("$ICONDIR"/rain.xbm)"
    #elif [[ $current_cond == *snow* ]]; then
            #icon="^i("$ICONDIR"/snow.xbm)"
    #else
            #icon="^i("$ICONDIR"/sun.xbm)"
    #fi
    #thermometer="^i("$ICONDIR"/temp.xbm)"
    #echo "^fg($L_CYAN)$icon^fg() $current_cond ^fg($L_CYAN)$thermometer^fg() $current_temp ^fg($L_CYAN)F ^fg($RED)$arrow^fg($L_CYAN)$arrow^fg($GRAY)$arrow^fg()"
#}

while true; do
    echo " $(VOLUME) $sep $(TIME) "
    sleep 1s
done | dzen2 -x '366' -y '0' -w '1000' -h '13' -bg '#1a1a1a' -fg '#f8f8f2' -ta r -e 'button1=;button2=;'
