#!/usr/bin/env bash
#
# last-tab plugin — action (bind to prefix+l).
#
# Focuses the previously-used tab in the current workspace (tmux `last-window`).
# Reads the MRU history written by record.sh. Focusing the previous tab fires
# tab.focused, which record.sh handles — so repeated presses toggle between the
# two most-recently-used tabs, exactly like tmux.

set -euo pipefail

herdr="${HERDR_BIN_PATH:-herdr}"
sd="${HERDR_PLUGIN_STATE_DIR:?}"
ws="${HERDR_WORKSPACE_ID:-}"
[ -n "$ws" ] || exit 0

f="$sd/mru-$ws"
[ -f "$f" ] || exit 0

prev=""
{ IFS= read -r prev || true; } < "$f"
[ -n "$prev" ] || exit 0

exec "$herdr" tab focus "$prev"
