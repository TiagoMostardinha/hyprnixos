#!/bin/sh
# Claude Code status line: saves the plan usage for the island and prints nothing (the status line stays empty).
# Claude Code passes it on stdin as rate_limits (five_hour and seven_day, each with used_percentage and
# resets_at) once a session has had its first reply. Without it, the last saved usage is kept.
out="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell/claude-usage.json"
usage=$(jq -c '.rate_limits // empty | {five_hour, seven_day}' 2> /dev/null)
[ -n "$usage" ] || exit 0
mkdir -p "$(dirname "$out")"
printf '%s\n' "$usage" > "$out.new" && mv "$out.new" "$out"
