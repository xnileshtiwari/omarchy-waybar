
#!/usr/bin/env bash
set -euo pipefail

out="$(/usr/bin/i3-gnome-pomodoro status --show-seconds 2>/dev/null || true)"

# Quit if idle or empty
[[ -z "$out" || "$out" =~ [Ii]dle ]] && exit 0

# Pull the first mm:ss we see
time="$(grep -Eo '[0-9]{1,3}:[0-9]{2}' <<<"$out" | head -n1)"
[[ -z "$time" ]] && exit 0

# Pick an icon by mode
icon="🍅"
if grep -qi 'break' <<<"$out"; then
  icon="☕"
fi

printf '%s %s\n' "$icon" "$time"
