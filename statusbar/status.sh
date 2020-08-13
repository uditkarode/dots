#!/bin/dash

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
    bat="$bat🔋 $bat_perc"
    send_warning
  elif [ "$bat_perc" -le 15 ]; then
    # use urgent colors
    bat="$bat🔋 $bat_perc"
  elif [ "$bat_perc" -le 25 ]; then
    bat="$bat🔋 $bat_perc"
  elif [ "$bat_perc" -le 50 ]; then
    bat="$bat🔋 $bat_perc"
  elif [ "$bat_perc" -le 75 ]; then
    bat="$bat🔋 $bat_perc"
  else
    bat="$bat🔋 $bat_perc"
  fi

  case "$status" in
    "Charging") bat="$bat 🔌";;
  esac

  echo " $bat"
}

read_volume() {
  var=$(pamixer --get-mute)

  vol=""
  case $var in
	  *'false') vol="$(pamixer --get-volume)";;
	  *'true') vol="MUTE";;
  esac

  if [ "$vol" -le 33 ] 2>/dev/null; then
    vol=" 🔈 $vol"
  elif [ "$vol" -le 67 ] 2>/dev/null; then
    vol=" 🔉 $vol"
  elif [ "$vol" -le 100 ] 2>/dev/null; then
    vol=" 🔊 $vol"
  elif [ "$vol" = "MUTE" ]; then
    vol=" 🔇 $(pamixer --get-volume)"
  fi

  # echo "$vol"
  echo "$vol  "
}

echo_date() {
  # istd=$(env TZ=Asia/Kolkata date +'%H:%M')
  var=$(date +'%a %d 📅 %H:%M')
  # echo "US $var IN $istd"
  # var=$(date +'%a %d %H:%M')
  echo "🕒 ${var}"
}

# Test 
# dstatus="$(read_battery)$(read_volume)$(read_spotify)$(echo_date)"
# xsetroot -name "${dstatus^^}"

read_weather(){
  weather
}

while true; do
    dstatus="$(read_battery)$(read_volume)$(read_weather)$(echo_date) "
    xsetroot -name "$dstatus"
    sleep 0.4s
done &

