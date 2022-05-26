#!/bin/dash

# orange color on both RAM sticks
openrgb --device 0 --mode static --color FF5100
openrgb --device 1 --mode static --color FF5100

# red, but looks orange on the motherboard lights
openrgb --device 4 --mode static --color FF1500

