#!/bin/bash
# brightness: Change all monitors brightness in software.
# by hackerb9, 2019

# Examples:  brightness 75;  brightness -5; brightness +10
# Usage:
#       brightess [n] [+n] [-n]
#       n       An integer from 0 to 100 specifies a brightness level.
#       +n      Increase brightness by n.
#       -n      Decrease brightness by n.
#               No argument shows current brightness level.

b=$(xrandr --current --verbose | grep Brightness)
b=${b#*: }                      # Remove "Brightness: "
b=${b#0.}                       # 0.30 --> 30
[[ $b == "1.0" ]] && b="100"
case $1 in
    +*|-*)
        b=$((b $1))             # b=b+10,  b=b-10
        ;;
    [0-9]*)
        b=$1                    # b=75
        ;;
    *)
        echo $b; exit
        ;;
esac

[[ $b -lt 0 ]] && b=0
[[ $b -gt 100 ]] && b=100

if [[ $b -eq 100 ]]; then
    b=1.0
else
    b=0.$b
fi

outputs=$(xrandr --current | awk '$2 == "connected" {print $1}')
for o in $outputs; do
    xrandr --output $o --brightness $b
done   
