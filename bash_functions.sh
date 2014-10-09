#!/bin/bash

function diffhead {
    diff=vimdiff
    if [[ $# -ne 3 ]]; then
        echo "Usage: diffhead file1 file2 head_length"
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
    if [[ $1 -eq b ]]; then
        dir=Blog_Posts
    elif [[ $1 -eq t ]]; then
        dir=Thoughts
    elif [[ $1 -eq m ]]; then
        dir=Misc
    elif [[ $1 -eq w ]]; then
        dir=Worklog
    fi
    datestamp=`date "+%Y-%m-%d"`
    target=~/Dropbox/Notes/$dir/$datestamp
    if [[ -f $target ]]; then
        inc=1
        while [[ -f ${target}.${inc} ]]; do
            ((inc++))
        done
        target=${target}.${inc}
    fi
    echo $target
}
