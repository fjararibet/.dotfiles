export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

DISABLE_AUTO_UPDATE="true"

### For large repositories
# DISABLE_UNTRACKED_FILES_DIRTY="true"

export NVM_LAZY_LOAD=true

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-nvm
)

source $ZSH/oh-my-zsh.sh
# unsetopt share_history

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Aliases
alias zshconf="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias vim="nvim"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias changebg="$HOME/Pictures/Backgrounds/set_background.sh"
alias vimconf='cd ~/.config/nvim/ && nvim . && cd -'
alias tmuxconf='nvim ~/.config/tmux/tmux.conf'
alias comp='g++ -Wall -Wextra -pedantic -std=c++17 -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC'

# Env vars
export EDITOR="nvim"

##############
# fzf config #
##############
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude .venv'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

writecmd() { 
  if [[ -n $1 ]]; then
    LBUFFER="$LBUFFER$1"
  fi
}

#bind <C-f> to search home with fzf
find-all-files() {
  local result=$(fdfind . $HOME --type file --hidden --follow --exclude .git --exclude .venv | fzf)
  writecmd $result
}
zle -N find-all-files
bindkey '\C-f' find-all-files
# search all directories
search-all-dirs() {
  local result=$(fdfind . $HOME -I --type directory --follow --exclude .git | fzf)
  writecmd $result 
}
zle -N search-all-dirs
bindkey "\ed" search-all-dirs

search-dirs() {
  local result=$(fdfind -I --type directory --hidden --follow --exclude .git | fzf)
  writecmd $result
}
zle -N search-dirs
bindkey "\ee" search-dirs
##############
#  end fzf   #
##############


# these were used to traverse the history
# but I want to use them for tmux
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

[ -f ~/.cargo/env ] && source ~/.cargo/env

# opam configuration
[[ ! -r /home/ciruela/.opam/opam-init/init.zsh ]] || source /home/ciruela/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(uv generate-shell-completion zsh)"
