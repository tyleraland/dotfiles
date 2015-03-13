#!/bin/bash

##### Colors #######
COLOR_NONE="\[\e[0m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
PURPLE="\[\033[0;35\]"
LIGHT_GRAY="\[\033[0;37m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
YELLOW="\[\033[1;33m\]"
BLUE="\[\033[1;34m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
WHITE="\[\033[1;37m\]"
#####################

function diffhead {
    diff=vimdiff
    if [[ $# -ne 3 ]]; then
        echo "Usage: head_length diffhead file1 file2"
        return $E_BADARGS
    fi
    if [[ -x "$(type -p $diff)" ]]; then
        $diff <(head -n $1 $2) <(head -n $1 $3)
    else
        echo "$diff not found in path -- defaulting to diff"
        diff <(head -n $1 $2) <(head -n $1 $2)
    fi
}

function dt {
    if [[ -z $1 ]]; then
        echo `date "+%Y-%m-%d"`
        return 0
    fi
# Experimental "dropbox" datetime stamps
#    if [[ $1 = "b" ]]; then
#        dir=Blog_Posts
#    elif [[ $1 = "t" ]]; then
#        dir=Thoughts
#    elif [[ $1 = "m" ]]; then
#        dir=Misc
#    elif [[ $1 = "w" ]]; then
#        dir=Worklog
#    fi
#    datestamp=`date "+%Y-%m-%d"`
#    target=~/Dropbox/Notes/$dir/$datestamp
#    echo $target
}

function is_git_repository {
   git branch > /dev/null 2>&1
}
function set_git_branch {
   # Set the final branch string
   BRANCH=`parse_git_branch`
   local TIME=`fmt_time` # format time for prompt string
 }

 function parse_git_branch() {
   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
 }

 function parse_git_dirty() {
   [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
 }

fmt_time () { #format time just the way I likes it
    if [ `date +%p` = "PM" ]; then
        meridiem="pm"
    else
        meridiem="am"
    fi
    date +"%l:%M:%S$meridiem"|sed 's/ //g'
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${BLUE} "
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
  else
    BRANCH=''
  fi
  # Set the bash prompt variable.
  PS1="${PYTHON_VIRTUALENV}${GREEN}\w${RED} ${BRANCH}\n${PROMPT_SYMBOL}${COLOR_NONE} "
}
