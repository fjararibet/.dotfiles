setopt prompt_subst

async_repo_information() {
  local root relative_path branch git_status

  root=$(command git rev-parse --show-toplevel 2>/dev/null) || {
    print -n -- "%F{blue}%~%f"$'\0'
    return
  }

  relative_path=${PWD:A}
  [[ $relative_path == $root ]] && relative_path="" || relative_path="/${relative_path#$root/}"
  branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null || command git rev-parse --short HEAD)
  git_status=$(GIT_OPTIONAL_LOCKS=0 command git status --porcelain 2>/dev/null)
  print -n -- "%F{magenta}%B${root:t}${relative_path}%b%F{8} ${branch}${git_status:+*}%f"$'\0'
}

repo_information() {
  print -n -- "${_OMZ_ASYNC_OUTPUT[async_repo_information]}"
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
  prompt_exec_time=$(cmd_exec_time)
  unset cmd_timestamp
}

_omz_register_handler async_repo_information

PROMPT=$'\n%F{8}%n@%m:%f$(repo_information) %F{yellow}${prompt_exec_time}%f\n%(?.%F{cyan}.%F{red})$%f '
RPROMPT=""
