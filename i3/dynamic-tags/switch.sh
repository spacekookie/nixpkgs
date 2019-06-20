#!/bin/sh
### Move the focus to a particular workspace using dmenu.

set -u

I3MSG=$(command -v i3-msg) || exit 1
JQ=$(command -v jq) || exit 2

$I3MSG workspace $($I3MSG -t get_workspaces | $JQ -M '.[] | .name' | tr -d '"' | sort -u | dmenu -b -i "$@")
