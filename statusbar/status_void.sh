#! /bin/bash

# Status for dwm
send_warning() {
  notify-send "BATTERY CRITICAL $bat_perc%"
  sleep 5s
}

read_battery() {
  read -r now < "/sys/class/power_supply/BAT0/charge_now"
  read -r full < "/sys/class/power_supply/BAT0/charge_full"
  read -r status < "/sys/class/power_supply/BAT0/status"

  bat_perc=$(((now * 100) / full))

  bat=""
  if [ "$bat_perc" -le 10 ]; then
    # use warning colors
    bat+="\x04 🔋 $bat_perc"
    send_warning
  elif [ "$bat_perc" -le 15 ]; then
    # use urgent colors
    bat+="\x03 🔋 $bat_perc"
  elif [ "$bat_perc" -le 25 ]; then
    bat+="\x06 🔋 $bat_perc"
  elif [ "$bat_perc" -le 50 ]; then
    bat+="\x06 🔋 $bat_perc"
  elif [ "$bat_perc" -le 75 ]; then
    bat+="\x06 🔋 $bat_perc"
  else
    bat+="\x06 🔋 $bat_perc"
  fi

  case "$status" in
    "Charging") bat+=" 🔌";;
  esac

  echo -e "$bat \x01 "
}

read_volume() {
  var=$(amixer get Master)

  vol=""
  case $var in
    *'[on]') var=${var#*[}; var=${var%\%*}; var=${var%\%*}; vol+="$var";;
    *'[off]') vol+="MUTE";;
  esac

  if ([ "$vol" -le 33 ]) 2>/dev/null; then
    vol="\x03 🔈 $vol"
  elif ([ "$vol" -le 67 ]) 2>/dev/null; then
    vol="\x03 🔉 $vol"
  elif ([ "$vol" -le 100 ]) 2>/dev/null; then
    vol="\x03 🔊 $vol"
  elif [ "$vol"=="MUTE" ]; then
    vol="\x04 🔇"
  fi

  # echo -e "$vol"
  echo -e "$vol \x01 "
}

echo_date() {
  # istd=$(env TZ=Asia/Kolkata date +'%H:%M')
  var=$(date +'%a %d 📅 %H:%M')
  # echo -e "US $var IN $istd"
  # var=$(date +'%a %d %H:%M')
  echo -e "\x07 🕒 ${var}"
}

# Test 
# dstatus="$(read_battery)$(read_volume)$(read_spotify)$(echo_date)"
# xsetroot -name "${dstatus^^}"

read_weather(){
    echo -e "$(weather)"
}

while true; do
    dstatus="$(read_battery)$(read_volume)$(read_weather)$(echo_date) "
  xsetroot -name "${dstatus^^}"
  sleep 0.4s
done &

