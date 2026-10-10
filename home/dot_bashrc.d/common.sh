# Bash configuration for macOS and Linux. ~/.bashrc loads this file after the OS file.
# SCRIPTS_DIR is the path of the awilmore/scripts repo. ~/.bashrc sets it.

# For GPG
export GPG_TTY=$(tty)


####################
# PS1 settings
####################

source $SCRIPTS_DIR/keep/mygitprompt.sh
export GOS="$HOME/go/src/github.com/mx51"

# The colour of the brackets and the path. An OS file can set it. The default is cyan.
PS1_COLOUR="${PS1_COLOUR:-1;36}"
export PS1='\[\033['"$PS1_COLOUR"'m\][\[\033[0;34m\]($(date +"%d %H:%M")) \[\033['"$PS1_COLOUR"'m\]$(gos_path)\[$(git_colour)\]$(git_status)\[\033['"$PS1_COLOUR"'m\]]\[\e[0m\] '


####################
# PATH settings
####################

export PATH=$PATH:$HOME/bin

# Custom scripts
export PATH="$PATH:$SCRIPTS_DIR/keep"

# Golang paths
export PATH="$HOME/go/bin:$PATH"

# For krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# For uv
export PATH="$HOME/.local/bin:$PATH"


####################
# OKTA SSO AWS/EKS
####################

# Okta login
alias sso-admin='aws-sso aws-administrator'

# AWS profiles
alias mx-admin-audit='set-default-profile mx-admin-audit'
alias mx-admin-domains='set-default-profile mx-admin-domains'
alias mx-admin-groundcover='set-default-profile mx-admin-groundcover'
alias mx-admin-hub-main-eng='set-default-profile mx-admin-hub-main-eng'
alias mx-admin-hub-main-mc='set-default-profile mx-admin-hub-main-mc'
alias mx-admin-hub-main-perf='set-default-profile mx-admin-hub-main-perf'
alias mx-admin-hub-main-mx='set-default-profile mx-admin-hub-main-mx'
alias mx-admin-identity='set-default-profile mx-admin-identity'
alias mx-admin-main-cba='set-default-profile mx-admin-main-cba'
alias mx-admin-main-eng='set-default-profile mx-admin-main-eng'
alias mx-admin-main-fisvau='set-default-profile mx-admin-main-fisvau'
alias mx-admin-main-gko='set-default-profile mx-admin-main-gko'
alias mx-admin-main-next='set-default-profile mx-admin-main-next'
alias mx-admin-main-perf='set-default-profile mx-admin-main-perf'
alias mx-admin-main-play='set-default-profile mx-admin-main-play'
alias mx-admin-main-pospay='set-default-profile mx-admin-main-pospay'
alias mx-admin-main-till='set-default-profile mx-admin-main-till'
alias mx-admin-main-wbc='set-default-profile mx-admin-main-wbc'
alias mx-admin-master='set-default-profile mx-admin-master'
alias mx-admin-nonprod-integration='set-default-profile mx-admin-nonprod-integration'
alias mx-admin-prod-integration='set-default-profile mx-admin-prod-integration'
alias mx-admin-runner='set-default-profile mx-admin-runner'
alias mx-admin-support-ai='set-default-profile mx-admin-support-ai'
alias mx-admin-tools='set-default-profile mx-admin-tools'
alias mx-admin-ztna='set-default-profile mx-admin-ztna'
alias mx-pu-main-eng='set-default-profile mx-pu-main-eng'

# Cluster logins
alias dev-main-eng='ekmx dev-main-eng'
alias dev-nonprod-integration='ekmx dev-nonprod-integration'
alias dev-support-ai='ekmx dev-support-ai'
alias live-main-cba='ekmx live-main-cba'
alias live-main-fisvau='ekmx live-main-fisvau'
alias live-main-gko='ekmx live-main-gko'
alias live-main-next='ekmx live-main-next'
alias live-main-play='ekmx live-main-play'
alias live-main-pospay='ekmx live-main-pospay'
alias live-main-till='ekmx live-main-till'
alias live-main-wbc='ekmx live-main-wbc'
alias live-ops-shared='ekmx live-ops-shared'
alias live-prod-integration='ekmx live-prod-integration'
alias load-main-perf='ekmx load-main-perf'
alias qa-main-eng='ekmx qa-main-eng'
alias qa-nonprod-integration='ekmx qa-nonprod-integration'
alias rnd-main-perf='ekmx rnd-main-perf'
alias sb-main-cba='ekmx sb-main-cba'
alias sb-main-fisvau='ekmx sb-main-fisvau'
alias sb-main-gko='ekmx sb-main-gko'
alias sb-main-next='ekmx sb-main-next'
alias sb-main-play='ekmx sb-main-play'
alias sb-main-pospay='ekmx sb-main-pospay'
alias sb-main-till='ekmx sb-main-till'
alias sb-main-wbc='ekmx sb-main-wbc'


####################
# ENV variables
####################

# For MSP
export WORKDIR=$GOS

# Golang
export GOPATH="$HOME/go"
export GO111MODULE=on
export GOPRIVATE="github.com/mx51"

# Command history stuff
export HISTSIZE=10000000
export HISTFILESIZE=10000000
export HISTCONTROL="ignorespace"
export HISTIGNORE="f:f *"

# Terminal
export EDITOR=vim

# Secrets. The file is not in git. Copy it to each system by hand.
[ -r $HOME/.secrets ] && source $HOME/.secrets

# Azure scripts
export TF_IMPLEMENTATION_AZURE_DIR=$HOME/git/devops/tf/tf-implementation-azure


####################
# WORKSPACE setup
####################

# Required for vim (see "set directory" in ~/.vimrc)
mkdir -p $HOME/tmp/vi_swap


###
# ALIAS shortcuts
###

# Python
alias pactivate="source .venv/bin/activate"
alias va=". .venv/bin/activate"

# Docker
alias docker-login="docker login -u awilmore -p $DOCKER_PW"

# To commands and scripts
alias kn='kubenodes'
alias yamllint='yamllint --no-warnings -c ~/.yamllint.yml'
alias eip="evil-ip.sh"
alias c='cd ..'
alias lsd='ls -lartd */'
alias lad='ls -lartd */'
alias lart='la'
alias acklong='ack -C 2'
alias acki='ack -i'
alias acks='ack --color --noxyz -i -g'
alias grep='grep -i '
alias agrep='grep -i -a '
alias less='less -X --RAW-CONTROL-CHARS'
alias x='xargs'
alias dush='du -sh'

alias htop='sudo htop'
alias kl='kubectl'
alias ch='claude -p hello'
alias aw='az-watch-build'

# Git
alias pr="pr.sh"
alias compare="compare.sh"

# Git add commit push function
ga() {
  MSG="$1"
  git add . && git commit -m "$MSG" && git pu
}

gc() {
  MSG="$1"
  git add . && git commit -m "$MSG"
}

# My scripts
alias ct='converttime'

# Useful
alias mx51io="docker login -u aquam8 -p $DOCKER_PW_MX"
alias gos="cd $GOS"
alias devops="cd ~/git/devops"
alias tf="cd ~/git/devops/tf"


####################
# FUNCTIONS
####################

# kubectl drain command
function drain() {
  if [ -z "$1" ]; then
    echo "usage: drain node_name"
  else
    kubectl drain $1 --ignore-daemonsets --delete-emptydir-data
  fi
}

# Git clone shortcut for mx51 repos
function clone() {
  if [ -z "$1" ]; then
    echo "usage: clone (repo name)"
  else
    git clone git@github.com:mx51/${1}.git
  fi
}

# Execute command against last command run (eg. which script.sh; f vi)
function f() {
  LAST=$(fc -n -l -1 -1);
  if [ $# = 1 ]; then
    echo "Executing: $1 \`$LAST\` ..."
    sleep 1
    $1 `$LAST`
  else
    echo $LAST
  fi
}
alias f=f

# awk shortcut
function a() {
  if [ $# = 3 ]; then
    awk "{print \$${1} \"$2\" \$${3}}"
  else
    awk "{print \$${1}}"
  fi
}

# env grep shortcut
function ev() {
  if [ $# = 1 ]; then
    env | grep -i $1
  else
    env | less
  fi
}

# list reverse time order function
function la() {
  if [ -z "$1" ]; then
    ls -lart
  else
    ls -lart | grep -i "$1"
  fi
}


###################
# Claude
###################

alias claude="claude --permission-mode auto"
alias claudesafe="~/.local/bin/claude"

alias kb="cd $HOME/claude/knowledge-base"
alias remote="cd $HOME/git/vibe/remote-workspace"

claude-whoami() {
  python3 -c "
import json, os
try:
    with open(os.path.expanduser('~/.claude.json')) as f:
        d = json.load(f)
    a = d.get('oauthAccount', {})
    print(f\"Account : {a.get('emailAddress', 'unknown')}\")
except Exception as e:
    print(f'Error: {e}')
" 2>/dev/null
}

alias cs="cswap switch"


####################
# Tmux sessions
####################

alias ta=tmuxattachsession
alias tl=tmuxlistsessions

# Only run in interactive shells, outside tmux, if the attach script is installed.
if [[ $- == *i* ]] && [ -z "$TMUX" ] && [ -x $HOME/.local/bin/tmuxattachsession ]; then
  $HOME/.local/bin/tmuxattachsession
fi
