function __kakoune --description "Wrapper around starting and re-attaching to kakoune sessions"
  set server_name (basename (pwd) | sed 's/\./-/g')
  set socket_file (kak -l | grep $server_name)
  set seek_point $argv[1]

  if test -n ! $seek_point
    return 130
  end
  
  if test -z $socket_file
    kak -d -s $server_name
  end

  kak -e "edit $seek_point" -c $server_name
end

function __kakoune_get_file_list --description "Get list of files to consider for fzf"
  git status ^ /dev/null > /dev/null
  if test $status -eq 0
    git ls-files -oc --exclude-standard
  else
    find .
  end
end

function __kakoune_get_folder_list --description "Get list of folder to consider for fzf"
  find . -type d
end
