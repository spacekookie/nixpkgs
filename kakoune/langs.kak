###
### Language specifics below 👇
###

## `.chapter` is just `.md` in disguise
hook global BufCreate .*[.](chapter) %{
  set-option buffer filetype markdown
}

## `.chapter` is just `.md` in disguise
hook global BufCreate .*[.](nix) %{
  set-option buffer filetype nix
}

## Rust specific settings
hook global WinSetOption filetype=rust %{
  set window formatcmd 'rustfmt'
}

hook global WinSetOption filetype=rust %{
  set window makecmd 'cargo build'
}

## yaml uses 2 tab indent
hook global WinSetOption filetype=(yaml|ruby|python|kak|nix) %{
  set-option buffer indentwidth 2
}

