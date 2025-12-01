#! /bin/bash

# Define PID file
PID_FILE="/tmp/cava_waybar.pid"

# Function to cleanup on exit
cleanup() {
  # Kill child processes (cava)
  pkill -P $$ 2>/dev/null
  # Kill monitor process if it exists
  [ -n "$MONITOR_PID" ] && kill "$MONITOR_PID" 2>/dev/null
  # Remove config file
  rm -f "/tmp/polybar_cava_config"
  # Remove PID file
  rm -f "$PID_FILE"
}

# Kill any existing cava.sh processes (except current script)
for pid in $(pgrep -f "cava.sh"); do
  if [ "$pid" != "$$" ]; then
    kill -9 "$pid" 2>/dev/null
    sleep 0.1
  fi
done

# Kill any existing cava processes
pkill -9 -f "cava -p /tmp/polybar_cava_config" 2>/dev/null
sleep 0.2

# Clean up any stale PID file
rm -f "$PID_FILE"

# Write current PID to file
echo $$ >"$PID_FILE"

# Set trap to run cleanup on exit or termination
trap cleanup EXIT TERM INT

bar="⠀⡀⣀⣄⣤⣦⣶⣷⣿"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]; do
  dict="${dict}s/$i/${bar:$i:1}/g;"
  i=$((i = i + 1))
done

# write cava config
config_file="/tmp/polybar_cava_config"
echo "
[general]
bars = 4

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 5
" >$config_file

# Start waybar monitoring as independent process
setsid bash -c '
    echo "Starting waybar monitoring..." >&2
    while pgrep -x "waybar" > /dev/null 2>&1; do
        sleep 1
    done
    echo "Waybar terminated, cleaning up cava processes..." >&2
    pkill -9 -f "cava.sh" 2>/dev/null || true
    pkill -9 -f "cava -p /tmp/polybar_cava_config" 2>/dev/null || true
    rm -f "/tmp/polybar_cava_config" "/tmp/cava_waybar.pid" 2>/dev/null || true
    echo "Cleanup completed" >&2
' &
disown

# Store monitor PID for cleanup
MONITOR_PID=$!

# read stdout from cava
cava -p "$config_file" | sed -u "$dict"
