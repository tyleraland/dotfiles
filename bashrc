# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# BUG: This breaks pip inside virtualenvs
#if [[ "Linux" == $(uname) ]]; then
#    export PYTHONPATH=/usr/local/lib/python2.7/site-packages
#fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
umask 0002

set -o vi

export EDITOR="vim"
export VISUAL="vim"

# Prevent control characters from disabling input/output
# TIP: Ctrl-S / Ctrl-Q lock/unlock
stty -ixon

if [ -f ~/.get-completion.bash ]; then
    source ~/.git-completion.bash
fi

# Green/blue prompt for regular users
PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

if [[ $(uname -s) == "Darwin" ]]; then
    #PATH=/Users/tal/anaconda/bin:$PATH
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

# Ensure that ssh-agent is alive
if [ ! "$(ps x | grep -v grep | grep ssh-agent)" ]; then
    eval $(ssh-agent -s)
fi

## This block keeps ssh-agent persistent, even throughout tmux sessions
## we're not in a tmux session
#if [ ! -z "$SSH_TTY" ]; then # We logged in via SSH
#    # if ssh auth variable is missing
#    if [ -z "$SSH_AUTH_SOCK" ]; then
#        export SSH_AUTH_SOCK="$HOME/.ssh/.auth_socket"
#    fi
#    # if socket is available create the new auth session
#    if [ ! -S "$SSH_AUTH_SOCK" ]; then
#        `ssh-agent -a $SSH_AUTH_SOCK` > /dev/null 2>&1
#        echo $SSH_AGENT_PID > $HOME/.ssh/.auth_pid
#    fi
#    # if agent isn't defined, recreate it from pid file
#    if [ -z $SSH_AGENT_PID ]; then
#        export SSH_AGENT_PID=`cat $HOME/.ssh/.auth_pid`
#    fi
#    # Add keys to ssh auth
#    for key in id_rsa github_rsa; do
#        ssh-add -l | grep "$key" > /dev/null
#        if [ $? -ne 0 ]; then
#            ssh-add ~/.ssh/$key
#        fi
#    done
#fi

get_ssh_sock(){
    sock=$(find /tmp/ssh-* -user $USER -name "agent.*" 2> /dev/null | head -1)
    if [[ -z $sock ]]; then
    eval $(ssh-agent -s)
    fi
    find /tmp/ssh-* -user $USER -name "agent.*" 2> /dev/null | head -1
}

ssh-refresh() {
    echo shell: SSH_AUTH_SOCK=$SSH_AUTH_SOCK
    export SSH_AUTH_SOCK=$(get_ssh_sock)
    echo shell: SSH_AUTH_SOCK=$SSH_AUTH_SOCK
    if [[ -n $TMUX ]]; then
    TMUX_SOCK=$(echo $TMUX|cut -d , -f 1)
    echo -n 'tmux: '; tmux -S $TMUX_SOCK showenv | grep SSH_AUTH_SOCK
    tmux -S $TMUX_SOCK setenv SSH_AUTH_SOCK $SSH_AUTH_SOCK
    echo -n 'tmux: '; tmux -S $TMUX_SOCK showenv | grep SSH_AUTH_SOCK
    fi

    local NEW_DISPLAY=$(tmux showenv | grep -E "^DISPLAY" | cut -d= -f2)
    if [[ -n $NEW_DISPLAY ]]; then
    print "Display: $NEW_DISPLAY"
    export DISPLAY=$NEW_DISPLAY
    fi
}

if [ -f ~/.bash_functions.sh ]; then
    source ~/.bash_functions.sh
fi

if [ -f ~/.bash_local.sh ]; then
    source ~/.bash_local.sh
fi

