# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

if [ -f ~/.bash_functions.sh ]; then
    source ~/.bash_functions.sh
fi

if [ -f ~/.bash_local.sh ]; then
    source ~/.bash_local.sh
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Ctrl-D must be pressed twice
export IGNOREEOF=1

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


#### Color Prompt ####
#### Defined in bash_functions.sh
PROMPT_COMMAND=set_bash_prompt
######################

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    #test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    test -r ~/dotfiles/colors/dircolors.ansi-dark && eval "$(dircolors -b ~/dotfiles/colors/dircolors.ansi-dark)" || eval "$(dircolors -b)"

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [[ $(uname -s) == "Darwin" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.

alias path='readlink -e'

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

# set -o vi

export EDITOR="vim"
export VISUAL="vim"

# Prevent control characters from disabling input/output
# TIP: Ctrl-S / Ctrl-Q lock/unlock
stty -ixon

if [[ -f ~/.git-completion.sh ]]; then
    source ~/.git-completion.sh
fi

# PATHs

# /usr/local/bin, then /usr/bin/
PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

if [[ $(uname -s) == "Darwin" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home)

    # Set tab name to local host
    echo -ne "\033]0;$HOSTNAME\007"

    # Wrap ssh command to give custom tab name
    # Use an alias, not a wrapper script in PATH because that conflicts with
    # ssh proxy commands
    alias ssh=~/.bin/ssh
    export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin"
fi

# # Set up rbenv for homebrew
# if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Ensure that ssh-agent is alive
if [ ! "$(ps x | grep -v grep | grep ssh-agent)" ]; then
    eval $(ssh-agent -s)

    # Add keys to ssh auth
    for key in id_rsa github_rsa; do
        ssh-add -l | grep "$key" > /dev/null
        if [ $? -ne 0 ]; then
            ssh-add ~/.ssh/$key
        fi
    done
fi

get_ssh_sock(){
    sock=$(find /tmp/ssh-* -user $USER -name "agent.*" 2> /dev/null | head -1)
    if [[ -z $sock ]]; then
    eval $(ssh-agent -s)
    fi
    find /tmp/ssh-* -user $USER -name "agent.*" 2> /dev/null | head -1
}

# ssh_refresh() {
#     echo shell: SSH_AUTH_SOCK=$SSH_AUTH_SOCK
#     export SSH_AUTH_SOCK=$(get_ssh_sock)
#     echo shell: SSH_AUTH_SOCK=$SSH_AUTH_SOCK
#     if [[ -n $TMUX ]]; then
#     TMUX_SOCK=$(echo $TMUX|cut -d , -f 1)
#     echo -n 'tmux: '; tmux -S $TMUX_SOCK showenv | grep SSH_AUTH_SOCK
#     tmux -S $TMUX_SOCK setenv SSH_AUTH_SOCK $SSH_AUTH_SOCK
#     echo -n 'tmux: '; tmux -S $TMUX_SOCK showenv | grep SSH_AUTH_SOCK
#     fi
# 
#     local NEW_DISPLAY=$(tmux showenv | grep -E "^DISPLAY" | cut -d= -f2)
#     if [[ -n $NEW_DISPLAY ]]; then
#     print "Display: $NEW_DISPLAY"
#     export DISPLAY=$NEW_DISPLAY
#     fi
# }
# # Ensure that ssh-agent is alive
# if [ ! "$(ps x | grep -v grep | grep ssh-agent)" ]; then
#     eval $(ssh-agent -s)
# 
#     # Add keys to ssh auth
#     for key in id_rsa github_rsa; do
#         ssh-add -l | grep "$key" > /dev/null
#         if [ $? -ne 0 ]; then
#             ssh-add ~/.ssh/$key
#         fi
#     done
# else # Check if ssh socket is lost and if so, refresh it
#     ssh-add -l >/dev/null
#     if [ $? -eq 2 ]; then
#         ssh_refresh
#     fi
# fi

# Fixes tmux issue where symlinks are expanded to canonical file names
[ "x${PWD#/mnt/disk2/molmicro}" != "x$PWD" ] && cd /molmicro${PWD#/mnt/disk2/molmicro}

# "mount cloud desktop" alias
# https://groups.google.com/forum/#!topic/macfusion-devel/D3A8tyTsApw
# https://w.amazon.com/index.php/VideoAds/Team/DevelopmentEnvironment/IntelliJOnMac#Mounting_Desktop_Drive
alias mc='sshfs clouddev: ~/remote -p 22 -o reconnect,no_readahead,noappledouble,nolocalcaches,compression=no,ServerAliveInterval=1,transform_symlinks,follow_symlinks,uid=$(id -u),gid=$(id -g),allow_other'

export PATH="/apollo/env/SDETools/bin:$PATH"

# Add all the scripts in VideoAdsTeamUtils to your PATH.
# Setup your machine for Perforce.
# Set default aliases
# And more (look at the source!)
if [ $(uname) == "Darwin" ]; then
    source /Users/ttyll/Code/VideoAdsTeamUtils/src/VideoAdsTeamUtils/shell/videoads.env
fi
