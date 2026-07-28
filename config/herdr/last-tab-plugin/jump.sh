#!/usr/bin/env bash
#
# last-tab plugin — action. Usage: jump.sh <tab|workspace>
#
#   tab       → previously-used tab in this workspace (prefix+l,       tmux last-window)
#   workspace → previously-used workspace             (prefix+shift+l, tmux last-session)
#                also on prefix+alt+l, to bounce back to the agent you came from
#
# Reads the MRU history written by record.sh. Each focus command fires the event
# record.sh listens on, so the old current becomes the new previous — repeated
# presses toggle between the two most-recently-used entries, exactly like tmux.

set -euo pipefail

kind="${1:?usage: jump.sh <tab|workspace>}"
herdr="${HERDR_BIN_PATH:-herdr}"
sd="${HERDR_PLUGIN_STATE_DIR:?}"
ws="${HERDR_WORKSPACE_ID:-}"

case "$kind" in
  tab)       [ -n "$ws" ] || exit 0; f="$sd/mru-tab-$ws" ;;
  workspace)                         f="$sd/mru-workspace" ;;
  *) echo "jump.sh: unknown kind: $kind" >&2; exit 2 ;;
esac

[ -f "$f" ] || exit 0

prev=""
{ IFS= read -r prev || true; } < "$f"
[ -n "$prev" ] || exit 0

case "$kind" in
  tab)       exec "$herdr" tab focus "$prev" ;;
  workspace) exec "$herdr" workspace focus "$prev" ;;
esac
