#!/bin/dash
SINK="$(pactl info | grep -i 'sink' | sed 's/Default Sink: //')"
SOURCE="$(pactl info | grep -i 'source' | sed 's/Default Source: //')"

SPEAKER_SINK="alsa_output.pci-0000_00_1f.3.analog-stereo"
HDMI_SINK="alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra2"

AUDIO_DEVICE=""

if [ "$SINK" = "$SPEAKER_SINK" ]; then
  AUDIO_DEVICE="${AUDIO_DEVICE}SPKR"
elif [ "$SINK" = "$HDMI_SINK" ]; then
  AUDIO_DEVICE="${AUDIO_DEVICE}HDMI"
fi
if [ -z "$(echo "$SOURCE" | grep 'monitor')" ]; then
  # the input device is a microphone of some sort
  AUDIO_DEVICE="${AUDIO_DEVICE}+MIC"
fi

echo "$AUDIO_DEVICE"
