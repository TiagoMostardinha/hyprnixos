#!/bin/sh
# Prints the Claude plan usage as two whole percentages: "<5-hour session> <week>", e.g. "32 64".
# Reads the Claude CLI login in ~/.claude/.credentials.json. While its access token is still valid (by its
# expiry time) it only asks for the usage. Once expired, it refreshes the token once (the only write, to
# that file) and then asks; if anything fails it prints nothing (and notifies, once per boot) and waits for
# the next check. Tokens only pass through files and stdin, never command arguments.
creds="$HOME/.claude/.credentials.json"
[ -f "$creds" ] || exit 1

usage() {
    jq -r '"Authorization: Bearer \(.claudeAiOauth.accessToken)"' "$creds" |
        curl -s --max-time 10 -H @- -H "anthropic-beta: oauth-2025-04-20" https://api.anthropic.com/api/oauth/usage |
        jq -er '"\(.five_hour.utilization | round) \(.seven_day.utilization | round)"'
}

refresh() {
    resp=$(jq -c '{grant_type: "refresh_token", client_id: "9d1c250a-e61b-44d9-88ed-5944d1962f5e", refresh_token: .claudeAiOauth.refreshToken}' "$creds" |
        curl -s --max-time 25 -X POST https://platform.claude.com/v1/oauth/token \
            -H "Content-Type: application/json" -H "anthropic-beta: oauth-2025-04-20" -d @-)
    printf '%s' "$resp" | jq -e '.access_token | strings' > /dev/null || return 1
    (
        umask 077
        printf '%s' "$resp" | jq -s '.[1] as $r | .[0]
            | .claudeAiOauth.accessToken = $r.access_token
            | .claudeAiOauth.refreshToken = ($r.refresh_token // .claudeAiOauth.refreshToken)
            | .claudeAiOauth.expiresAt = ((now + $r.expires_in) * 1000 | floor)' "$creds" - > "$creds.new"
    ) && mv "$creds.new" "$creds"
}

# A failed refresh or usage request sends one notification, at most once per boot (the marker lives in
# the runtime dir, which is emptied at shutdown).
notify() {
    marker="${XDG_RUNTIME_DIR:-/tmp}/claude-usage-notified"
    [ -e "$marker" ] && return
    touch "$marker"
    notify-send -a Claude -i "$(cd "$(dirname "$0")/.." && pwd)/assets/claude.svg" "$1" "$2"
}

{
    if ! jq -e '.claudeAiOauth.expiresAt / 1000 > now' "$creds" > /dev/null && ! refresh; then
        notify "Couldn't refresh the Claude login" "Run claude in a terminal to log in again."
        exit 1
    fi
    usage || { notify "Couldn't read the Claude usage" "It will try again in 30 minutes."; exit 1; }
} 2> /dev/null
