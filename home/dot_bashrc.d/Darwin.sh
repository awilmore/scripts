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
# Open files in Typora, then move each file window to the top-right corner
# of the external monitor, at 70% of the screen width and 90% of the height.
# With no files, move the front Typora window.
unalias md 2>/dev/null
function md() {
  open -a Typora "$@" || return
  local names=()
  local f
  for f in "$@"; do names+=("$(basename "$f")"); done
  [ ${#names[@]} -gt 0 ] || names=("")
  # Start the moves from a subshell, so that they are not jobs of this shell.
  # Thus the prompt returns at once, and bash shows no job messages.
  (
    for f in "${names[@]}"; do
      window_place Typora "$f" 0.7 0.9 &
    done
  )
}


###
# Window placement
###

# Move an app window to the top-right corner of the external monitor.
# If no external monitor is connected, the built-in screen is used.
# The terminal app must have the Accessibility permission.
# The window is the first window whose title starts with <title start>.
# If <title start> is empty, the front window of the app is used.
# The function waits up to 30 seconds for the window, because some apps start
# slowly after a reboot. Errors go to /tmp/window_place.log.
# Usage: window_place <process name> <title start> <width ratio> <height ratio>
# Example: window_place SmartGit "scripts - SmartGit" 0.8 1
function window_place() {
  osascript -l JavaScript - "$@" >/dev/null 2>>/tmp/window_place.log <<'EOF'
ObjC.import("AppKit");
function run(argv) {
  var proc = argv[0];
  var title = argv[1] || "";
  var wr = parseFloat(argv[2]);
  var hr = parseFloat(argv[3]);
  var se = Application("System Events");

  // Find the window. The result is null if there is no such window.
  function findWin() {
    var procs = se.processes.whose({ name: proc });
    if (procs.length === 0) { return null; }
    var wins = procs[0].windows();
    for (var j = 0; j < wins.length; j++) {
      var name = wins[j].name() || "";
      if (name.indexOf(title) === 0) { return wins[j]; }
    }
    return null;
  }

  var win = null;
  for (var i = 0; i < 150 && !win; i++) {
    try { win = findWin(); } catch (e) { win = null; }
    if (!win) { delay(0.2); }
  }
  if (!win) { throw new Error("no " + proc + " window that starts with: " + title); }

  // Use the first screen that is not the built-in screen.
  // Screen 0 has the menu bar. Its height converts Cocoa Y to window Y.
  var screens = $.NSScreen.screens;
  var mainH = screens.objectAtIndex(0).frame.size.height;
  var target = screens.objectAtIndex(0);
  for (var k = 0; k < screens.count; k++) {
    var s = screens.objectAtIndex(k);
    if (ObjC.unwrap(s.localizedName).indexOf("Built-in") < 0) { target = s; break; }
  }
  var v = target.visibleFrame;
  var w = Math.round(v.size.width * wr);
  var h = Math.round(v.size.height * hr);
  var x = Math.round(v.origin.x + v.size.width - w);
  var y = Math.round(mainH - (v.origin.y + v.size.height));

  // An app can replace the window or set its own bounds while it starts.
  // Thus find the window again, set the bounds, and make sure that they stay.
  // Set the position again after the size, because macOS can move a window
  // that is larger than the space that is available.
  // macOS can make the window smaller than asked, for example below the
  // menu bar. Thus compare with the bounds that the window had after the
  // last change, not with the bounds that were asked for.
  var done = null;
  for (var n = 0; n < 10; n++) {
    delay(0.5);
    try {
      win = findWin();
      if (!win) { continue; }
      var now = String(win.position()) + "," + String(win.size());
      if (now === done) { return "moved"; }
      win.position = [x, y];
      win.size = [w, h];
      win.position = [x, y];
      done = String(win.position()) + "," + String(win.size());
    } catch (e) {
      // The window changed while it was in use. Try again.
    }
  }
  return "moved";
}
EOF
}


###
# SmartGit functions
###

# sgit alias
alias sgit='smartgit --args $PWD &'

# smartgit shortcut
# The last argument is the repository folder. If it is not a folder, the
# current folder is used. The repository window moves to the right edge of
# the external monitor, at 80% of the width and the full height.
function smartgit() {
  echo "Running smartgit..."
  open -a "SmartGit.app" -n "$@"
  local dir="${*: -1}"
  [ -d "$dir" ] || dir="$PWD"
  local top
  top="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null || echo "$dir")"
  window_place SmartGit "$(basename "$top") - SmartGit" 0.8 1
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

alias gemini="$HOME/.nvm/versions/node/v24.4.0/bin/gemini --model gemini-3.1-pro-preview --approval-mode=auto_edit"


###################
# Misc
###################

alias vm='ssh adam@192.168.0.50'
