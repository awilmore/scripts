#!/bin/bash

function show_color() {
  local cname=$1
  local cval=$2
  printf "\e[${cval}[root@ulpcop015 /root] %-11s - %-10s\n" $cname $cval
  echo "export PS1='\[\e[${cval}\][\u@\h \${PWD}\[\e[0;31m\]\$(__git_ps1 \" (%s)\")\[\e[${cval}\]]\[\e[0m\] '"
  echo "export PS1='\[\e[${cval}\][\u@\h \${PWD}]\[\e[0m\] '"
  printf "\n";
}

# COLORS
DARK_BLACK='0;30m'
LITE_BLACK='1;30m'

DARK_RED='0;31m'
LITE_RED='1;31m'

DARK_GREEN='0;32m'
LITE_GREEN='1;32m'

DARK_YELLOW='0;33m'
LITE_YELLOW='1;33m'

DARK_BLUE='0;34m'
LITE_BLUE='1;34m'

DARK_PURPLE='0;35m'
LITE_PURPLE='1;35m'

DARK_CYAN='0;36m'
LITE_CYAN='1;36m'

LITE_WHITE='1;37m'

NO_COLOR='0m'

show_color "DARK_RED" $DARK_RED
show_color "LITE_RED" $LITE_RED

show_color "DARK_GREEN" $DARK_GREEN
show_color "LITE_GREEN" $LITE_GREEN

show_color "DARK_YELLOW" $DARK_YELLOW
show_color "LITE_YELLOW" $LITE_YELLOW

show_color "DARK_BLUE" $DARK_BLUE
show_color "LITE_BLUE" $LITE_BLUE

show_color "DARK_PURPLE" $DARK_PURPLE
show_color "LITE_PURPLE" $LITE_PURPLE

show_color "DARK_CYAN" $DARK_CYAN
show_color "LITE_CYAN" $LITE_CYAN

show_color "LITE_BLACK" $LITE_BLACK
show_color "LITE_WHITE" $LITE_WHITE


