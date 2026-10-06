# Bash configuration for Linux (the remote workspace). ~/.bashrc loads this file before common.sh.

####################
# IMPORTS
####################

export PATH="$HOME/.local/bin:$PATH"

# The colour of the brackets and the path in PS1 (dark green). common.sh uses it.
PS1_COLOUR='0;32'

# mise puts the user tools on the PATH. A non-interactive shell (for example "ssh ws <command>") uses the shims.
if command -v mise > /dev/null; then
  if [[ $- == *i* ]]; then
    eval "$(mise activate bash)"
  else
    export PATH="$HOME/.local/share/mise/shims:$PATH"
  fi
fi

if [[ $- == *i* ]]; then
  # For bash completion
  [ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

  # For CTRL-R fuzzy command finder
  command -v fzf > /dev/null && eval "$(fzf --bash)"

  # For autojump
  [ -r /usr/share/autojump/autojump.bash ] && . /usr/share/autojump/autojump.bash
fi


###
# ALIAS shortcuts
###

alias ls='ls --color=auto'
alias vi='vim -b '

# tree function
function tree() {
  command tree -a -C -I '.git|.idea' "$@" | less -R -X
}
