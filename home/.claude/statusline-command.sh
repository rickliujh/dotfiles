#!/bin/bash
# Status line: home-relative working directory on the left; context usage,
# prompt cache expiry, and plan usage right-aligned.
#
# Fields are pulled from the JSON on stdin with bash regex rather than jq, which
# is not installed here. The status line renders on every update, so avoiding a
# subprocess per field also keeps it cheap.

shopt -s extglob
input=$(cat)

cwd=""
if [[ $input =~ \"current_dir\"[[:space:]]*:[[:space:]]*\"([^\"]*)\" ]]; then
  cwd="${BASH_REMATCH[1]}"
fi
[ -z "$cwd" ] && cwd="$PWD"

# Home-relative path, as a shell prompt would show it.
path="$cwd"
if [ "$cwd" = "$HOME" ]; then
  path="~"
elif [[ $cwd == "$HOME"/* ]]; then
  path="~${cwd#"$HOME"}"
fi
left=$'\033[01;37m'"$path"$'\033[00m'

# Right-hand segments are plain words separated by a dim bar. Labels are normal
# brightness; only a value that needs attention gets a color.
sep=$' \033[02;37m│\033[00m '
right=""
add() { right+="${right:+$sep}$1"; }

# Context window usage. Absent before any messages are sent, so anything other
# than a number is treated as unavailable and nothing is appended.
if [[ $input =~ \"used_percentage\"[[:space:]]*:[[:space:]]*([0-9]+(\.[0-9]+)?) ]]; then
  printf -v seg 'ctx %.0f%%' "${BASH_REMATCH[1]}"
  add "$seg"
fi

# Prompt cache state, from the "prompt_cache" object: the clock time the cache
# expires (an absolute time rather than a countdown, since the status line is
# not re-rendered while idle), or a red notice once it has.
if [[ $input =~ \"expires_at\"[[:space:]]*:[[:space:]]*([0-9]+) ]]; then
  exp="${BASH_REMATCH[1]}"
  printf -v now '%(%s)T' -1
  if [ "$now" -lt "$exp" ]; then
    printf -v seg 'cache until \033[00;32m%(%H:%M)T\033[00m' "$exp"
  else
    printf -v seg '\033[00;31mcache expired\033[00m'
  fi
  add "$seg"
fi

# Plan usage for the 5-hour session window, from "rate_limits" (absent for
# API-key sessions and before the first response), marked with ◷. The 7-day
# window is deliberately not shown. Printed as used, with the reset time. Yellow
# from 75% used, red from 90%.
re='"five_hour"[[:space:]]*:[[:space:]]*\{[^}]*"used_percentage"[[:space:]]*:[[:space:]]*([0-9]+)'
if [[ $input =~ $re ]]; then
  used="${BASH_REMATCH[1]}"
  color='00'
  [ "$used" -ge 75 ] && color='00;33'
  [ "$used" -ge 90 ] && color='00;31'
  printf -v seg '◷ \033[%sm%d%% used\033[00m' "$color" "$used"
  re='"five_hour"[[:space:]]*:[[:space:]]*\{[^}]*"resets_at"[[:space:]]*:[[:space:]]*([0-9]+)'
  if [[ $input =~ $re ]]; then
    printf -v reset ' \033[02;37m(resets %(%H:%M)T)\033[00m' "${BASH_REMATCH[1]}"
    seg+="$reset"
  fi
  add "$seg"
fi

# Pad between the two halves so the right one ends at the terminal edge. Widths
# are measured with the color escapes stripped. COLUMNS is set by Claude Code;
# the margin covers the status line's own horizontal padding. Without a usable
# width (or room), the right half simply follows the path.
margin=4
plain_left="${left//$'\033['*([0-9;])m/}"
plain_right="${right//$'\033['*([0-9;])m/}"
pad=$(( ${COLUMNS:-0} - margin - ${#plain_left} - ${#plain_right} ))
[ "$pad" -lt 2 ] && pad=2
[ -z "$right" ] && pad=0
printf '%s%*s%s' "$left" "$pad" '' "$right"
