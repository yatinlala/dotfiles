# https://srstevenson.com/posts/zsh-terminal-title/

autoload -Uz add-zsh-hook

_precmd_title() {
  # print -Pn "\e]0;%n@%m: %~\a"
  print -Pn "\e]0;zsh: %~\a"
}

_preexec_title() {
  # print -Pn "\e]0;zsh: %~ - $2\a"
}

add-zsh-hook precmd _precmd_title
add-zsh-hook preexec _preexec_title
