#!/bin/bash
###
# Create symlinks from the home directory to dotfiles in dotfiles/ and specified in Manifest
# NOTE:  This should NOT be invoked with 'source'
###

# Determine the directory where the script, and thus the dotfiles, live
# This should work regardless of the caller's cwd
SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BAK=$SRC/.backup
files=$(cat $SRC/Manifest)

# Back up previous dotfiles and install files from manifest
mkdir -p $BAK
for file in $files; do
    # Backup existing files and directories but not symlinks
    if [[ ( -f ~/.$file || -d ~/.$file ) && ! -L ~/.$file ]]; then
        mv ~/.$file $BAK/$file.old
    fi
    # If file in manifest is in our repo, then create a symlink to it in home with . prefix
    if [[ -f $SRC/$file ]]; then
        ln -sf $SRC/$file ~/.$file
    elif [[ -d $SRC/$file && ! -L ~/.$file ]]; then # Same for directories
        ln -sF $SRC/$file ~/.$file
    fi
done

mkdir -p $SRC/vim/bundle
# Vim plugins
if [[ ! -d $SRC/vim/bundle/vim-colors-solarized ]]; then
    git clone https://github.com/altercation/vim-colors-solarized $SRC/vim/bundle/vim-colors-solarized
fi
if [[ ! -d $SRC/vim/bundle/jedi-vim ]]; then
    git clone --recursive http://github.com/davidhalter/jedi-vim $SRC/vim/bundle/jedi-vim
fi
if [[ ! -d $SRC/vim/bundle/supertab ]]; then
    git clone --recursive https://github.com/ervandew/supertab.git $SRC/vim/bundle/supertab
fi
if [[ ! -d $SRC/vim/bundle/nerdtree ]]; then
    git clone --recursive https://github.com/scrooloose/nerdtree.git $SRC/vim/bundle/nerdtree
fi

source ~/.bashrc
