#!/usr/bin/env ruby

########################
#
# A small utilit script that adds all changed files from a
#   git repository and creates a commit with a timestamp.
#   It then also pushes the changes to the currently selected
#   upstream.
#
# I use this to quickly sync progress from my wiki
########################


# Get the path if it exists
path = ARGV[0]
exit unless path
err_time = 2500
date = Time.now.strftime("%d/%m/%Y_%H:%M")

# Check if the directory actually exists
unless File.directory?(path)
    `notify-send -u critical -t #{err_time} "Directory '#{path}' doesn't exist!"`
    exit
end

# Check if folder is git repo
Dir.chdir(path)
`git status 2>&1> /dev/null` ; ret = `echo $?`
unless ret
    `notify-send -u critical -t #{err_time} "Directory '#{path}' contains no git repo! :("`
    exit
end

# Check if we have new files
ret = `git status --porcelain`
if ret == ""
    `notify-send -u critical -t #{err_time} "Seems there were no new things to sync in your repository ¯\\_(ツ)_/¯"`
    exit
end

`git add --all 2>&1> /dev/null`
`git commit -m "Syncing progress from #{date} automatically..." 2>&1> /dev/null`
`git push`

`notify-send -u normal -t #{err_time} "#{path} was successfully synced :)"`
