#/bin/sh
# this script fetches all "usefull" information from the system
# it can be used to pipe the output to <bar ain't recursive>

wsp() {
		num=1
		cur=`xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}'`
		tot=`xprop -root _NET_NUMBER_OF_DESKTOPS | awk '{print $3}'`
		current=$(($cur + $num))
		echo "$current / $tot"
}

whoami(){ 
		tty
		echo " :: "
		id -u -n
		echo " :: "
		hostname
		echo " :: "
		uname
		echo " :: "
		uname -r
		echo " :: "
		uname -m	
}

ipaddress(){
		hostname --ip-address
}

#brightness(){
		#xbacklight -get | sed 's/\([a-zA-Z: \t]\)//g' | cut -d . -f 1
#}

clock() {
		date '+%d.%m.%y %H:%M'
}

battery() {
    #BATC=/sys/class/power_supply/BAT0/capacity
    BATS=/sys/class/power_supply/BAT0/status
    BATN=/sys/class/power_supply/BAT0/energy_now
    BATF=/sys/class/power_supply/BAT0/energy_full

    batt_now=$(cat $BATN) 
    batt_full=$(cat $BATF) 

    echo $batt_now/$batt_full*100 | bc -l | awk '{print int($1+0.5)}'
    #sed -n p $BATC
    echo "percent ::"
    test "`cat $BATS`" = "Charging" && echo -n 'charging' || echo -n 'discharging'
}

network() {
		ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "connected " || echo "disconnected "
}

memory(){
	  echo $(free -m | awk '/-/ {print $3}')
	  echo "mb :: used"
}

volume(){
		amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p'| uniq
}

while :; do 
		 buf="%{l}"
		 buf="${buf}%{F#C3AE93} $(whoami) %{F#A3A3A3}|"
		 buf="${buf}%{F#C3AE93} WSP:%{F#ffffff} $(wsp) %{F#A3A3A3}|"
		 buf="${buf}%{F#C3AE93} BAT:%{F#ffffff} $(battery) %{F#A3A3A3}%{c}"
		 buf="${buf}%{F#C3AE93} CLK:%{F#ffffff} $(clock) %{F#A3A3A3}%{r}"
		 buf="${buf}%{F#C3AE93} MEM:%{F#ffffff} $(memory) %{F#A3A3A3}|"
		 buf="${buf}%{F#C3AE93} IP:%{F#ffffff} $(ipaddress) %{F#A3A3A3}|"
		 buf="${buf}%{F#C3AE93} VOL:%{F#ffffff} $(volume) percent %{F#A3A3A3}|"
		 #buf="${buf}%{F#C3AE93} BRI:%{F#ffffff} $(brightness) percent %{F#A3A3A3}|"
		 buf="${buf}%{F#C3AE93} NET:%{F#ffffff} $(network)%{l} "
     echo $buf
		 sleep 1 # The HUD will be updated every second
done
