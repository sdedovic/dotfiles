# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# forgot why I need this
ZSH_DISABLE_COMPFIX=true

# Personal preferences
export EDITOR=vim
export VISUAL=vim
export BROWSER=firefox

# oh-my-zsh
export ZSH=${HOME}/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(archlinux aws colored-man-pages direnv docker extract fzf git gradle httpie systemd sudo terraform themes z)
source $ZSH/oh-my-zsh.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# webm2mp4
webm2mp4 () {
  NAME=`echo $1 | cut -d'.' -f1`
  NEW_NAME=${NAME}.mp4
  ffmpeg -i $1 -vcodec libx264 -crf 28 -pix_fmt yuv420p ${NEW_NAME}
  echo "$1 -> ${NEW_NAME}"
}

# tmux helpers
alias ta='tmux attach'
alias ts='tmux new -s'
alias tx='tmux resize-pane -x'
alias ty='tmux resize-pane -y'

# direnv python
setopt PROMPT_SUBST
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
      echo "($(basename $VIRTUAL_ENV))"
  fi
}
PS1='$(show_virtual_env)'$PS1

# sdkman
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"

# nvim
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# rvim
export PATH="$PATH:$HOME/.rvm/bin"

# cargo
if [ -e $HOME/.cargo/bin ] && [ -d $HOME/.cargo/bin ]; then export PATH=$HOME/.cargo/bin:$PATH; fi

# nix
if [ -e /home/stevan/.nix-profile/etc/profile.d/nix.sh ]; then . /home/stevan/.nix-profile/etc/profile.d/nix.sh; fi

# prompt stuff
if [[ -n "$DISPLAY" && -z "$TMUX" ]];
then
  exec tmux new-session;
fi

