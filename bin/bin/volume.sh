#!/bin/sh

clock() {
    date '+%Y-%m-%d %H:%M'
}


volume() {
    amixer get Master | sed -n 'N;s/^.*\[\([0-9]\+%\).*$/\1/p'

}

battery() {
    BATS=/sys/class/power_supply/BAT0/status
    BATN=/sys/class/power_supply/BAT0/energy_now
    BATF=/sys/class/power_supply/BAT0/energy_full

    batt_now=$(cat $BATN)
    batt_full=$(cat $BATF)

    echo $batt_now/$batt_full*100 | bc | awk '{print int($1+0.5)}'
    #echo $BATC

    test "`cat $BATS`" = "Charging" && echo -n '+' || echo -n '-'
}


while :; do
    buf=""
    #buf="${buf} [$(groups)]   --  "
    buf="${buf} CLK: $(clock) -"
    #buf="${buf} NET: $(network) -"
    #buf="${buf} CPU: $(cpuload)%% -"
    #buf="${buf} RAM: $(memused)%% -"
    buf="${buf} VOL: $(volume)%%"
    buf="${buf} BATT: $(battery)%%"
    #buf="${buf} MPD: $(nowplaying)"

    echo $buf
    sleep 1

done
