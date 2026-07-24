setopt prompt_subst

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable hg bzr git
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
zstyle ':vcs_info:*:*' formats "%%B%r%%b/%S" ":%b" "%%u%c"
zstyle ':vcs_info:*:*' actionformats "%%B%r%%b/%S" ":%b" "%u%c (%a)"
zstyle ':vcs_info:*:*' nvcsformats "%~" "" ""

git_dirty() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return
  command git diff --quiet --ignore-submodules HEAD &>/dev/null
  [ $? -eq 1 ] && echo "*"
}

repo_information() {
  echo "%F{magenta}${vcs_info_msg_0_%%/.}%F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
}

cmd_exec_time() {
  local stop=`date +%s`
  local start=${cmd_timestamp:-$stop}
  let local elapsed=$stop-$start
  [ $elapsed -gt 5 ] && echo ${elapsed}s
}

preexec() {
  [ -n "$TMUX" ] && tmux rename-window "${1%% *}"
  cmd_timestamp=`date +%s`
}

precmd() {
  setopt localoptions nopromptsubst
  vcs_info
  print -P "\n$(repo_information) %F{yellow}$(cmd_exec_time)%f"
  unset cmd_timestamp
}

PROMPT="%(?.%F{cyan}.%F{red})$%f "
RPROMPT="%F{8}${SSH_TTY:+%n@%m}%f"
