#!/usr/bin/env bash
#
# herdr-nav.sh — vim-aware Ctrl+h/j/k/l navigation, herdr side.
# Bound in config.toml as: herdr-nav.sh <left|down|up|right>  (type = "shell").
#
# If the focused pane runs Vim/Neovim in the foreground, forward the matching
# Ctrl chord into it so Vim moves between its own splits (and, at a split edge,
# the Neovim side crosses back into herdr — see nvim vim-tmux-navigator spec).
# Otherwise, move herdr's pane focus directly.
#
# ─────────────────────────────────────────────────────────────────────────────
# PROVENANCE — this is a vendored, adapted copy of navigate.sh from:
#   https://github.com/paulbkim-dev/vim-herdr-navigation
#   copied from commit 53e318c (2026-06-28)
#
# We keep our own copy instead of `herdr plugin install/link` so it stays purely
# declarative: a plain symlinked file with no imperative plugin registration.
# ⇒ TODO: every so often, diff against upstream navigate.sh and pull in fixes,
#   especially if herdr changes the `pane process-info` JSON shape or key syntax.
#
# Divergences from upstream (why the copy isn't byte-for-byte):
#   • Env: shell-keybind commands get HERDR_ACTIVE_PANE_ID (not HERDR_PANE_ID),
#     so we target the pane with `--pane "$pane"` instead of `--current`.
#   • jq is optional here: upstream requires it; we fall back to grep so this
#     works without adding a jq dependency to the dotfiles installers.
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

dir="${1:?usage: herdr-nav.sh <left|down|up|right>}"
herdr="${HERDR_BIN_PATH:-herdr}"
pane="${HERDR_ACTIVE_PANE_ID:-}"

case "$dir" in
  left)  key="ctrl+h" ;;
  down)  key="ctrl+j" ;;
  up)    key="ctrl+k" ;;
  right) key="ctrl+l" ;;
  *) echo "herdr-nav.sh: unknown direction: $dir" >&2; exit 2 ;;
esac

# Foreground process names that mean "Vim is in control of this pane".
# Same matcher vim-tmux-navigator uses: vi, vim, nvim, view, gvim, *diff, ...
vim_re='^g?(view|l?n?vim?x?)(diff)?$'

# Opt-in passthrough for non-Vim TUIs that own Ctrl+h/j/k/l themselves
# (lazygit, k9s, ...). ERE matched against the lower-cased process name; anchor
# it (^…$) for an exact match. Empty (default) forwards only Vim.
#   export HERDR_NAV_PASSTHROUGH_RE='^(lazygit|k9s)$'
passthrough_re="${HERDR_NAV_PASSTHROUGH_RE:-}"

forward=0
if [ -n "$pane" ]; then
  info="$("$herdr" pane process-info --pane "$pane" 2>/dev/null || true)"
  if command -v jq >/dev/null 2>&1; then
    # Faithful upstream path: response nests foreground_processes under process_info.
    if printf '%s' "$info" | jq -e \
        --arg vim "$vim_re" --arg pass "$passthrough_re" \
        '.result.process_info.foreground_processes[]?.name
         | ascii_downcase
         | select(test($vim) or ($pass != "" and (try test($pass) catch false)))' \
        >/dev/null 2>&1; then
      forward=1
    fi
  else
    # Fallback without jq: match process "name" fields with the same regexes.
    names="$(printf '%s' "$info" | tr -d ' \t\n' \
      | grep -oE '"name":"[^"]*"' | sed -E 's/"name":"([^"]*)"/\1/' \
      | tr '[:upper:]' '[:lower:]' || true)"
    while IFS= read -r n; do
      [ -n "$n" ] || continue
      if printf '%s' "$n" | grep -qE "$vim_re" \
         || { [ -n "$passthrough_re" ] && printf '%s' "$n" | grep -qE "$passthrough_re"; }; then
        forward=1
        break
      fi
    done <<EOF
$names
EOF
  fi
fi

if [ "$forward" -eq 1 ]; then
  exec "$herdr" pane send-keys "$pane" "$key"
else
  exec "$herdr" pane focus --direction "$dir" --pane "$pane"
fi
