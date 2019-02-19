#!/bin/sh
### Utility to select a new workspace name

I3MSG=$(command -v i3-msg) || exit 1
JQ=$(command -v jq) || exit 2

echo $($I3MSG -t get_workspaces | $JQ -M '.[] | .name' | tr -d '"' | sort -u | dmenu -b -i "$@")

