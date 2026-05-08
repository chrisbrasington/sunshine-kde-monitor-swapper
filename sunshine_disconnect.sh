#!/bin/bash
export WAYLAND_DISPLAY=/run/user/1000/wayland-0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/sunshine.conf"

echo "Sunshine disconnect: restoring $STREAM_MONITOR to $RESTORE_MODE and setting $PRIMARY_MONITOR as primary..."

kscreen-doctor "output.$STREAM_MONITOR.mode.$RESTORE_MODE" "output.$PRIMARY_MONITOR.priority.1"

if [ $? -eq 0 ]; then
    echo "Done: $STREAM_MONITOR is now $RESTORE_MODE, $PRIMARY_MONITOR is priority 1."
else
    echo "Error: kscreen-doctor failed (exit code $?)."
    exit 1
fi
