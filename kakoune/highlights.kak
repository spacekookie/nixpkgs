# Custom highlighers and such

decl -hidden regex curword

hook global NormalIdle .* %{
    eval -draft %{ try %{
        exec <space><a-i>w <a-k>\`\w+\'<ret>
        set buffer curword "\b\Q%val{selection}\E\b"
    } catch %{
        set buffer curword ''
    } }
}

hook global WinCreate .* %{
  add-highlighter window/ dynregex '%opt{curword}' 0:+b
}
