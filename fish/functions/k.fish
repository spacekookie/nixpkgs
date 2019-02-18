# Spawn a kak daemon in a project directory and fuzzy open a file
function k --description='Open kakoune via skim'
    set server_name (basename (pwd) | sed 's/\./-/g')
    set socket_file (kak -l | grep $server_name)

    if test -z $socket_file
        kak -d -s $server_name 
    end
    
    # Find out if we're in a git repo
    git status ^ /dev/null > /dev/null

    if test $status -eq 0
        kak (git ls-files -oc --exclude-standard | sk) -c $server_name $argv
    else
        kak (sk) -c $server_name $argv
    end
end

