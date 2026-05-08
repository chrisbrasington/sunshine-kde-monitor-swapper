#!/bin/bash
export WAYLAND_DISPLAY=/run/user/1000/wayland-0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/sunshine.conf"

echo "Sunshine connect: setting $STREAM_MONITOR to $STREAM_MODE and making it primary..."

kscreen-doctor "output.$STREAM_MONITOR.mode.$STREAM_MODE" "output.$STREAM_MONITOR.priority.1"

if [ $? -eq 0 ]; then
    echo "Done: $STREAM_MONITOR is now $STREAM_MODE, priority 1."
else
    echo "Error: kscreen-doctor failed (exit code $?)."
    exit 1
fi

if grep -q '"BigPictureInForeground"\s*"1"' "$HOME/.steam/registry.vdf" 2>/dev/null; then
    echo "Steam Big Picture already active."
else
    echo "Launching Steam Big Picture..."
    setsid steam steam://open/bigpicture >/dev/null 2>&1 &
fi
