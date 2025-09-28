#!/bin/bash

if pgrep -f "floating-status" > /dev/null; then
    # Kill the status window
    pkill -f "floating-status"
else
    # Start the status window
		alacritty --class=floating-status \
          --option window.dimensions.columns=32 \
          --option window.dimensions.lines=5 \
          --option font.size=10 \
          --option window.padding.x=10 \
          --option window.padding.y=6 \
          --option window.dynamic_padding=false \
          -e ~/bin/bspwm/status &
fi
