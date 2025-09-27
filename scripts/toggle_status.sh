#!/bin/bash

if pgrep -f "floating-status" > /dev/null; then
    # Kill the status window
    pkill -f "floating-status"
else
    # Start the status window
    kitty --class=floating-status \
          -o initial_window_width=320 \
          -o initial_window_height=140 \
					-o font_size=12 \
          -o remember_window_size=no \
          -o window_padding_width=10 \
          ~/bin/bspwm/status &
fi
