#!/usr/bin/env bash
#
# last-tab plugin — event hook. Usage: record.sh <tab|workspace>
#
# Maintains most-recently-used histories so jump.sh can toggle back to the
# previous one (tmux `last-window`, extended to workspaces):
#
#   tab       ← tab.focused        per workspace   → prefix+l
#   workspace ← workspace.focused  session-wide    → prefix+shift+l, prefix+alt+l
#
# herdr passes HERDR_WORKSPACE_ID / HERDR_TAB_ID (the newly focused ones) to
# plugin commands plus a private HERDR_PLUGIN_STATE_DIR to persist state — so no
# JSON parsing / jq needed.
#
# State file: two lines — line 1 = previous, line 2 = current.

set -euo pipefail

kind="${1:?usage: record.sh <tab|workspace>}"
sd="${HERDR_PLUGIN_STATE_DIR:?}"
ws="${HERDR_WORKSPACE_ID:-}"

case "$kind" in
  tab)
    [ -n "$ws" ] || exit 0
    id="${HERDR_TAB_ID:-}"
    f="$sd/mru-tab-$ws"
    ;;
  workspace)
    id="$ws"
    f="$sd/mru-workspace"
    ;;
  *)
    echo "record.sh: unknown kind: $kind" >&2
    exit 2
    ;;
esac

[ -n "$id" ] || exit 0

prev=""
curr=""
if [ -f "$f" ]; then
  { IFS= read -r prev || true; IFS= read -r curr || true; } < "$f"
fi

# Only shift history when the focused entry actually changed. The old current
# becomes the new previous; the newly focused one becomes current.
if [ "$id" != "$curr" ]; then
  printf '%s\n%s\n' "$curr" "$id" > "$f"
fi
