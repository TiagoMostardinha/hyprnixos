#!/bin/sh
# Prints the Claude plan usage as two whole percentages: "<5-hour session> <week>", e.g. "32 64".
# Reads the Claude CLI login in ~/.claude/.credentials.json. When its access token expires within
# 5 minutes it is refreshed first (the only write, to that file). Prints nothing on any failure.
# Tokens only pass through files and stdin, never command arguments.
creds="$HOME/.claude/.credentials.json"
[ -f "$creds" ] || exit 1

if jq -e '.claudeAiOauth.expiresAt / 1000 < now + 300' "$creds" > /dev/null; then
    resp=$(jq -c '{grant_type: "refresh_token", client_id: "9d1c250a-e61b-44d9-88ed-5944d1962f5e", refresh_token: .claudeAiOauth.refreshToken}' "$creds" |
        curl -s --max-time 25 -X POST https://platform.claude.com/v1/oauth/token \
            -H "Content-Type: application/json" -H "anthropic-beta: oauth-2025-04-20" -d @-)
    printf '%s' "$resp" | jq -e '.access_token | strings' > /dev/null || exit 1
    (
        umask 077
        printf '%s' "$resp" | jq -s '.[1] as $r | .[0]
            | .claudeAiOauth.accessToken = $r.access_token
            | .claudeAiOauth.refreshToken = ($r.refresh_token // .claudeAiOauth.refreshToken)
            | .claudeAiOauth.expiresAt = ((now + $r.expires_in) * 1000 | floor)' "$creds" - > "$creds.new"
    ) && mv "$creds.new" "$creds" || exit 1
fi

jq -r '"Authorization: Bearer \(.claudeAiOauth.accessToken)"' "$creds" |
    curl -s --max-time 10 -H @- -H "anthropic-beta: oauth-2025-04-20" https://api.anthropic.com/api/oauth/usage |
    jq -er '"\(.five_hour.utilization | round) \(.seven_day.utilization | round)"'
