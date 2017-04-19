##bash_alias file##

##shortcuts##
#clear terminal
alias c='clear'
#history shortcut
alias h='history'
#jobs shortcut
alias j='jobs -l'
#make path env var easier to read
alias path='echo -e ${PATH//:/\\n}'
#show date/time
alias now='date +"%T"'
alias nowtime='now'
alias nowdate='date +"%d-%m-%y"'
#create parent dirs if needed
alias mkdir='mkdir -pv'
alias ev='evince'

##ls##
#use a long listing format
alias ll='ls -ltrh'
alias la='ls -ltrha'
#show subdirs
alias lr='ls -R'
#show hidden files
alias l.='ls -d .*'
alias ll.='ls -dltrh .*'
#list only directories
alias ld='ls -d */'
##cd##
#get rid off error from mistyping
alias cd..='cd ..'
#quickly navigate directories
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../'

##admin stuff##
#become root
#alias root='sudo -i'
alias su='sudo -i'
#install with apt-get
alias apt-get='sudo apt-get'
#update with all yes
alias updatey='sudo apt-get update --yes'
#update with one command
alias update='sudo apt-get update && sudo apt-get upgrade'

##reboot/halt/poweroff
alias reboot='sudo /sbin/reboot'
#alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

#colorised output of difference in files
alias diff='colordiff'

#make mount easier to read
alias mount='mount |column -t'

#start calculator with mathlibrary
alias bc='bc -l'

alias b='source ~/.bashrc'
alias shell='$SHELL'

alias dv2ps='dvips -Ppdf'

alias screens_off=' xset s off'
alias screens_on=' xset s on'

alias jdownloader='./bin/jd2/JDownloader2'

alias conda_activate='source /home/abdi/anaconda2/bin/activate ~/anaconda2'
alias conda_deactivate='source /home/abdi/anaconda2/bin/deactivate'

alias poweroff='su -c "'"systemctl poweroff"'"'

alias printhome='lpr -P DCP1610W'
alias printcol='lpr -P mono'
alias printninja='lpr -P HP_Officejet_Pro_X576dw_MFP'
