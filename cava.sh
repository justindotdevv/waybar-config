#! /bin/bash

# Function to cleanup on exit
cleanup() {
  # Kill child processes (cava)
  pkill -P $$ 2>/dev/null
  # Remove config file
  rm -f "/tmp/waybar_cava_config"
}

# Kill any existing cava.sh processes (except current script)
for pid in $(pgrep -f "cava.sh"); do
  if [ "$pid" != "$$" ]; then
    kill -9 "$pid" 2>/dev/null
    sleep 0.1
  fi
done

# Kill any existing cava processes
pkill -9 -f "cava -p /tmp/waybar_cava_config" 2>/dev/null

# Set trap to run cleanup on exit or termination
trap cleanup EXIT TERM INT

# Original bars: bar=" ▂▃▄▅▆▇█"
bar="⠀⡀⣀⣄⣤⣦⣶⣷⣿"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]; do
  dict="${dict}s/$i/${bar:$i:1}/g;"
  ((i++))
done

# write cava config
config_file="/tmp/waybar_cava_config"
echo "
[general]
bars = 6
framerate = 30

[smoothing]
monstercat = 0
gravity = 100

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 8
" >$config_file

# read stdout from cava
cava -p "$config_file" | sed -u "$dict"
