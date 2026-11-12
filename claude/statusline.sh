#!/bin/bash
# Claude Code status line: model, reasoning effort, context window usage.
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
EFFORT=$(echo "$input" | jq -r '.effort.level // empty')

USED_TOKENS=$(echo "$input" | jq -r '((.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0))')
MAX_TOKENS=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Human-readable token counts (e.g. 15.5k)
fmt_tokens() {
    local n=$1
    if [ "$n" -ge 1000 ]; then
        awk -v n="$n" 'BEGIN { printf "%.1fk", n/1000 }'
    else
        echo "$n"
    fi
}
USED_FMT=$(fmt_tokens "$USED_TOKENS")
MAX_FMT=$(fmt_tokens "$MAX_TOKENS")

# Colour-blind-safe (Okabe-Ito) 256-colour palette: blue -> orange -> vermillion.
# Never green/red: that pair is the one red-green colour blindness cannot tell apart.
BLUE='\033[38;5;32m'; ORANGE='\033[38;5;214m'; VERMILLION='\033[1;38;5;166m'; RESET='\033[0m'
MARK=""
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$VERMILLION"; MARK=" !"   # glyph, so the warning isn't colour-only
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$ORANGE"
else BAR_COLOR="$BLUE"; fi

BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
[ "$FILLED" -gt "$BAR_WIDTH" ] && FILLED=$BAR_WIDTH
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /▓}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

EFFORT_SEG=""
[ -n "$EFFORT" ] && EFFORT_SEG=" | effort:${EFFORT}"

printf '[%s]%s %b%s%b %s%%%s (%s/%s)\n' "$MODEL" "$EFFORT_SEG" "$BAR_COLOR" "$BAR" "$RESET" "$PCT" "$MARK" "$USED_FMT" "$MAX_FMT"
