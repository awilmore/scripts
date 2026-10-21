# Bash configuration for macOS. ~/.bashrc loads this file before common.sh.

####################
# IMPORTS
####################

export PATH="$PATH:/opt/homebrew/bin"

# For CTRL-R fuzzy command finder
eval "$(fzf --bash)"

# For bash completion
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# For autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh


####################
# PATH settings
####################

export PATH=$PATH:/usr/local/bin

# Host paths
export PATH=$PATH:$HOME/Applications:/opt/homebrew/sbin

# Golang paths
export PATH="/usr/local/go/bin:$PATH"

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin


####################
# ENV variables
####################

# Terminal
export TERM=xterm-color
#export TERM=xterm-256color
export GREP_OPTIONS='--color=auto -i'
export GREP_COLOR='1;32'
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Required for vim
mkdir -p /tmp/vi_swap

# WARP for Claude and Gemini
export NODE_EXTRA_CA_CERTS="$HOME/.agents/warp.pem"


###
# ALIAS shortcuts
###

# Python
alias python="/opt/homebrew/bin/python3"

# PyCharm
alias charm="open -b com.jetbrains.pycharm"

alias k9s='TERM=xterm-256color /opt/homebrew/bin/k9s'
alias v='gvim -b '
alias v.='gvim -b '
alias vi='/opt/homebrew/bin/vim -b '
alias vim='/opt/homebrew/bin/gvim -b '
alias ls='ls -G'
alias lessv='vim -u /usr/share/vim/vim73/macros/less.vim'
alias psql='/Applications/pgAdmin\ 4.app/Contents/SharedSupport/psql'

# WARP
alias warp='source $SCRIPTS_DIR/keep/warp-env.sh'

# Diff
alias vimdiff=gvimdiff
alias diff=$SCRIPTS_DIR/keep/diff

# Git
alias git=/opt/homebrew/bin/git
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

# My scripts
alias sudo=$SCRIPTS_DIR/keep/sudo

# Useful
alias e='open .'
alias ssh='touch ~/.ssh/known_hosts && rm ~/.ssh/known_hosts && ssh -o StrictHostKeyChecking=no '

# Markdown
# Open files in Typora. Hammerspoon moves each new window to the top-right
# corner of the external monitor (see ~/.hammerspoon/init.lua).
unalias md 2>/dev/null
function md() {
  open -a Typora "$@"
}


###
# SmartGit functions
###

# sgit alias
alias sgit='smartgit --args $PWD &'

# smartgit shortcut
# Hammerspoon moves each new SmartGit window to the top-right corner of the
# external monitor (see ~/.hammerspoon/init.lua).
function smartgit() {
  echo "Running smartgit..."
  open -a "SmartGit.app" -n "$@"
}

# smartgit log shortcut
function sglog() {
  echo "Running sglog"
  LPATH="$1"
  if [ ! -f $1 ]; then
    LPATH="."
  fi
  /Applications/SmartGit.app/Contents/MacOS/SmartGit --log "$LPATH" >> /tmp/smartgit.log 2>&1 &
}

# smartgit blame shortcut
function sgblame() {
  echo "Running sgblame"
  LPATH="$1"
  if [ ! -f $1 ]; then
    LPATH="."
  fi
  /Applications/SmartGit.app/Contents/MacOS/SmartGit --blame "$LPATH" >> /tmp/smartgit.log 2>&1 &
}

# tree function
function tree() {
  /opt/homebrew/bin/tree -a -C -I '.git|.idea|.DS_Store' "$@" -a -C | less -R -X
}


###################
# GCLOUD
###################

source ~/.bash_gcloud
alias gauth="gcloud auth login adam@mx51.io"


###################
# Node and npm
###################

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


###################
# Claude
###################

claude-work() {
  BROWSER=~/.local/bin/claude-open-chrome claude auth login
}

claude-personal() {
  BROWSER=~/.local/bin/claude-open-safari claude auth login
}


###################
# Gemini
###################

#alias gemini="$HOME/.nvm/versions/node/v24.4.0/bin/gemini --model gemini-3.1-pro-preview --approval-mode=auto_edit"
alias gemini="$HOME/.nvm/versions/node/v24.4.0/bin/gemini --model gemini-4-argon --approval-mode=auto_edit"


###################
# Misc
###################

alias vm='ssh adam@192.168.0.50'
