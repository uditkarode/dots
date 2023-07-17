#!/usr/bin/env bash

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)

RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
LGREEN='\033[0;32m'
LPURP='\033[0;35m'
ORANGE='\033[0;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
BLUE='\033[0;34m'
NC='\033[0m'

b=$(tput bold)
n=$(tput sgr0)

function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    #print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    print_selected()   { printf "${BLUE}${b}>>${NC}${n} $1"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = j ]]; then echo j;  fi
                         if [[ $key = k ]]; then echo k;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up|k)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down|j)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

echo "What kind of commit is this?"
echo

options=(
  "${b}${BLUE}fix${NC}${n} - fixed something"
  "${b}${LGREEN}feat${NC}${n} - added a new feature"
  "${b}${RED}rm${NC}${n} - removed file(s) or feature(s)"
  "${b}${CYAN}refactor${NC}${n} - significant code changes without affecting functionality"
  "${b}${YELLOW}cleanup${NC}${n} - moved things around, not qualified enough to be a refactor"
  "${b}${LPURP}doc${NC}${n} - wrote or modified docs"
  "${b}${LPURP}ver${NC}${n} - added or modified versions"
  "${b}${LPURP}chore${NC}${n} - some code related action that does not affect end-users"
)

select_option "${options[@]}"
choice=$?

case $choice in
    0) ACTION="fix" ;;
    1) ACTION="feat" ;;
    2) ACTION="rm" ;;
    3) ACTION="refactor" ;;
    4) ACTION="cleanup" ;;
    5) ACTION="doc" ;;
    6) ACTION="ver" ;;
    7) ACTION="chore" ;;
esac

echo -ne "${b}${CYAN}Affected module${NC}${n}: "
read SCOPE
echo -ne "${b}${CYAN}Change description${NC}${n}: "
read DESCRIPTION

if [ -z "$SCOPE" ]; then
	git commit -m "${ACTION}: ${DESCRIPTION}"
else
	git commit -m "${ACTION}(${SCOPE}): ${DESCRIPTION}"
fi

