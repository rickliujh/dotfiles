#!/usr/bin/env bash
#
# last-tab plugin — event hook (runs on every tab.focused).
#
# Maintains a per-workspace most-recently-used tab history so prefix+l can jump
# back to the previous tab (tmux `last-window`). herdr passes HERDR_WORKSPACE_ID
# and HERDR_TAB_ID (the newly focused tab) to plugin commands, and a private
# HERDR_PLUGIN_STATE_DIR to persist state — so no JSON parsing / jq needed.
#
# State file per workspace: two lines — line 1 = previous tab, line 2 = current.

set -euo pipefail

sd="${HERDR_PLUGIN_STATE_DIR:?}"
ws="${HERDR_WORKSPACE_ID:-}"
tab="${HERDR_TAB_ID:-}"
[ -n "$ws" ] && [ -n "$tab" ] || exit 0

f="$sd/mru-$ws"

prev=""
curr=""
if [ -f "$f" ]; then
  { IFS= read -r prev || true; IFS= read -r curr || true; } < "$f"
fi

# Only shift history when the focused tab actually changed. The old current
# becomes the new previous; the newly focused tab becomes current.
if [ "$tab" != "$curr" ]; then
  printf '%s\n%s\n' "$curr" "$tab" > "$f"
fi
