#!/bin/sh
### Move a window to a given workspace. If it doesn't exist it creates it.

I3MSG=$(command -v i3-msg) || exit 1
JQ=$(command -v jq) || exit 2

WORKSPACE=$($I3MSG -t get_workspaces | $JQ -M '.[] | .name' | tr -d '"' | sort -u | dmenu -b -i "$@")

# Move the window first
$I3MSG -t command move workspace $WORKSPACE

# Then move the user
$I3MSG workspace $WORKSPACE
