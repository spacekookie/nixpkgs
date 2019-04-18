#!/bin/bash
# This file is CC-0! Have fun with it :)

DEST="$1"

if [ -z "$DEST" ]; then exit 1; fi

rsync -azv --exclude 'target/' ./ ${DEST}

inotifywait -r -m -e close_write --format '%w%f' . |\
while read file
do
    if [[ $file == ./target* ]]; then
        continue
    fi

    echo $file
    rsync -azv --exclude 'target/' $file ${DEST}/$file
    echo -n 'Completed at '
    date
done
