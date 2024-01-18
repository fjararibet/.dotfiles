export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

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
alias vimconf='nvim ~/.config/nvim/'
alias tmuxconf='nvim ~/.config/tmux/tmux.conf'

# fzf config
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh


# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude .venv'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
function writecmd () { 
  perl -e 'ioctl STDOUT, 0x5412, $_ for split //, do{ chomp($_ = <>); $_ }' ; 
}

#bind <C-f> to search home with fzf
find-all-files() {
  fd . $HOME --type file --hidden --follow --exclude .git --exclude .venv | fzf | writecmd
}
zle -N find-all-files
bindkey '\C-f' find-all-files
# search all directories
search-all-dirs() {
  fd . $HOME -I --type directory --follow --exclude .git | fzf | writecmd
}
zle -N search-all-dirs
bindkey "\ed" search-all-dirs

search-dirs() {
  fd -I --type directory --hidden --follow --exclude .git | fzf | writecmd
}
zle -N search-dirs
bindkey "\ee" search-dirs

source "$HOME/.cargo/env"

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

