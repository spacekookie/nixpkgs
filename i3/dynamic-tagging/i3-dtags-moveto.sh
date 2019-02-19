#!/bin/sh
### Move a window to a given workspace. If it doesn't exist it creates it.

I3MSG=$(command -v i3-msg) || exit 1
JQ=$(command -v jq) || exit 2

## Using jq to extract the keys from the JSON array returned by i3-msg -t get_workspaces.
WORKSPACE=$($I3MSG -t get_workspaces | $JQ -M '.[] | .name' | tr -d '"' | sort -u | dmenu -b -i "$@")
# WORKSPACE=echo $(/home/spacekookie/.config/i3/dynamic-tagging/i3-dtags-select.sh)

# Move the window first
$I3MSG -t command move workspace $WORKSPACE

# Then move the user
$I3MSG workspace $WORKSPACE
