export PATH=$HOME/.local/bin:/usr/local/bin:$PATH

# Aliases
alias zshconf="nvim ~/.zshrc"
alias vim="nvim"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias changebg="$HOME/Pictures/Backgrounds/set_background.sh"
alias vimconf='cd ~/.config/nvim/ && nvim . && cd -'
alias tmuxconf='nvim ~/.config/tmux/tmux.conf'
alias comp='g++ -Wall -Wextra -pedantic -std=c++17 -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC'

export EDITOR="nvim"

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude .venv'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

writecmd() { 
  if [[ -n $1 ]]; then
    LBUFFER="$LBUFFER$1"
  fi
}

#bind <C-f> to search home with fzf
find-all-files() {
  local result=$(fd . $HOME --type file --hidden --follow --exclude .git --exclude .venv | fzf)
  writecmd $result
}
zle -N find-all-files
bindkey '\C-f' find-all-files
# search all directories
search-all-dirs() {
  local result=$(fd . $HOME -I --type directory --follow --exclude .git | fzf)
  writecmd $result 
}
zle -N search-all-dirs
bindkey "\ed" search-all-dirs

search-dirs() {
  local result=$(fd -I --type directory --hidden --follow --exclude .git | fzf)
  writecmd $result
}
zle -N search-dirs
bindkey "\ee" search-dirs


# these were used to traverse the history
# but I use them for tmux
bindkey -r "^[."
bindkey -r "^[,"

# Always start with a tmux session.
session_name="main"
# 1. First you check if a tmux session exists with a given name.
tmux has-session -t=$session_name 2> /dev/null
# 2. Create the session if it doesn't exists.
if [[ $? -ne 0 ]]; then
  TMUX='' tmux new-session -d -s "$session_name"
fi
# 3. Attach if outside of tmux, switch if you're in tmux.
if [[ -z "$TMUX" ]]; then
  tmux attach -t "$session_name"
else
  tmux switch-client -t "$session_name"
fi
