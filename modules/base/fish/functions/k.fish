# Spawn a kak daemon in a project directory and fuzzy open a file
function k --description='Open kakoune via fzf'
  # Select a file with `fzf`
  set file (__kakoune_get_file_list | fzf --height=25 --reverse)

  # Open the file 
  __kakoune $file
end

function ksm --description "Open a file at an exact line of code"
  set file (sk --ansi -c 'rg --color=always --line-number "{}"')
  set entry (echo $file | sed 's/\(\:[0-9]*\).*/\1/' | tr ':' ' ')

  echo $entry

  # Then open the file!
  __kakoune $entry
end
