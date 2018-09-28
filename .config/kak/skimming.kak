## A bunch of utilities around `skim`: https://github.com/lotabout/skim

# Some TODOs
# - Use i3-msg to ensure the split is always on the right side
# - Also use i3-msg to on-the-fly resize the focused terminal
#    so it takes up less than 50% of a split

define-command -docstring "open a file using skim" skim-files %{
  evaluate-commands %sh{
    TEMP=$(mktemp)
    kitty sh -c "git ls-files -oc --exclude-standard | sk > $TEMP"
    SELECTION=$(cat $TEMP)
    rm $TEMP
    printf 'edit %s' ${SELECTION}
  }
}
alias global sk skim-files

define-command -override -docstring 'invoke skim to select a buffer' skim-buffers %{
  evaluate-commands %sh{
    TEMP=$(mktemp)
    BUFFERS=$(echo ${kak_buflist} | sed "s/'//g")
    kitty sh -c "echo $BUFFERS | tr ' ' '\n' | sk > $TEMP"
    BUFFER=$(cat $TEMP)
    rm $TEMP
    printf 'buffer %s' $BUFFER
  }
}
alias global bfs skim-buffers

define-command -override -docstring 'Find some code in your project with `sk`' skim-code %{
  evaluate-commands %sh{
    TEMP=$(mktemp)
    kitty sh -c "sk --ansi -c 'rg --color=always --line-number \"{}\"' > $TEMP"
    SELECTION=($(cat $TEMP | sed 's/\(\:[0-9]*\).*/\1/' | tr ':' ' '))
    rm $TEMP
    printf 'edit %s %s' ${SELECTION[0]} ${SELECTION[1]}
  }
}
alias global skm skim-code
