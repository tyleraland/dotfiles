#!/bin/bash
###
# Create symlinks from the home directory to dotfiles in dotfiles/ and specified in Manifest
# NOTE:  This should NOT be invoked with 'source'
###

# Determine the directory where the script, and thus the dotfiles, live
# This should work regardless of the caller's cwd
# Note that now the script's cwd
SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BAK=$SRC/.backup
files=$(cat Manifest)

# Back up previous dotfiles and install files from manifest
mkdir -p $BAK
for file in $files; do
    # Only backup file if it is an existing file/dir and not a symlink
    if [[ ( -f ~/.$file || -d ~/.$file ) && ! -h ~/.$file ]]; then
        mv ~/.$file $BAK/$file.old
    fi
    if [ -f $SRC/$file ]; then
        ln -sf $SRC/$file ~/.$file
    elif [ -d $SRC/$file ]; then
        ln -sF $SRC/$file ~/.$file
    fi
done
