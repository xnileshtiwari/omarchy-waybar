
#!/usr/bin/env bash
set -euo pipefail
out="$(/usr/bin/i3-gnome-pomodoro status --show-seconds 2>/dev/null || true)"
[[ -z "$out" || "$out" =~ [Ii]dle ]] && exit 0
grep -qiE 'focus|pomodoro' <<<"$out" && printf 'FOCUS\n' || exit 0
