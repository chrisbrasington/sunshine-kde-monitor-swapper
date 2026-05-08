# Sunshine Steam Deck monitor switcher

Hook scripts and config for [Sunshine](https://github.com/LizardByte/Sunshine), the open-source game-stream host. Sunshine streams a Linux desktop or game to a Moonlight client (Steam Deck, phone, another PC) over the network — like GeForce Experience GameStream, but self-hosted and Linux-friendly.

This repo adds two things on top of a stock Sunshine install: a connect/disconnect hook that swaps a monitor to a Deck-friendly resolution while streaming and restores it afterward, and an `apps.json` entry that triggers it. Targets KDE Plasma on Wayland (`kscreen-doctor`).

When a stream starts, one monitor gets switched to a Deck-friendly resolution and made primary. When the stream ends, it goes back to normal and another monitor takes over as primary. Steam Big Picture launches on connect if it isn't already running.

## Files

- `apps.json` — Sunshine app list. Drop into `~/.config/sunshine/`.
- `sunshine_connect.sh` — runs on stream start.
- `sunshine_disconnect.sh` — runs on stream end.
- `sunshine.conf` — monitor names and resolutions. Edit this.
- `steamdeck.png` — icon for the "Steam Deck Desktop" app.

## Setup

1. Install Sunshine and `kscreen-doctor` (ships with KDE Plasma).
2. Copy this folder somewhere stable, e.g. `/home/youruser/sunshine`.
3. Edit `sunshine.conf` to match your setup. Run `kscreen-doctor -o` to see your output names and supported modes.
4. Make the scripts executable: `chmod +x sunshine_connect.sh sunshine_disconnect.sh`.
5. Point Sunshine at `apps.json`, or copy the entries into your existing one. Fix the absolute paths inside if you put the folder somewhere else.
6. Restart Sunshine.

## Config

`sunshine.conf` has four variables:

- `STREAM_MONITOR` — the monitor Sunshine captures. Made primary while streaming.
- `STREAM_MODE` — resolution it switches to on connect. Format: `WIDTHxHEIGHT@RATE`.
- `RESTORE_MODE` — what to switch back to on disconnect.
- `PRIMARY_MONITOR` — which monitor takes over as primary after disconnect.

### Finding your monitors

KDE ships `kscreen-doctor`. Run:

```
kscreen-doctor -o
```

Each connected output prints its name, current priority, and supported modes. Example with three monitors:

```
Output: 1 DP-1 ... priority 1     Modes: 2560x1440@144 ...
Output: 2 DP-3 ... priority 3     Modes: 2560x1440@144 ...
Output: 3 HDMI-A-1 ... priority 2 Modes: 1920x1080@60 ... 1280x800@59.81 ...
```

The names on the left (`DP-1`, `DP-3`, `HDMI-A-1`) are what go into `sunshine.conf`. Modes have to be picked from the list each output reports — not every monitor supports every resolution/refresh combo.

### Example: this setup

Three monitors. `DP-1` is the everyday primary. The Steam Deck has a native 1280x800 panel, so when streaming starts, `HDMI-A-1` gets dropped from 1920x1080 to 1280x800. On disconnect it goes back to 1920x1080.

```
STREAM_MONITOR="HDMI-A-1"
STREAM_MODE="1280x800@60"
RESTORE_MODE="1920x1080@60"
PRIMARY_MONITOR="DP-3"
```

### Why primary matters

Most games launch on the primary monitor. Switching `STREAM_MONITOR` to priority 1 on connect makes the game open on the monitor Sunshine is capturing — otherwise it lands on a 1440p monitor the Deck can't see. On disconnect, `PRIMARY_MONITOR` takes priority 1 back so the desktop returns to normal.

## Notes

- Wayland-only. The `WAYLAND_DISPLAY` line at the top of each script assumes UID 1000. Change it if yours differs.
- The Big Picture check reads `~/.steam/registry.vdf`. If Steam isn't installed there, that block is harmless — it just always tries to launch BP.
