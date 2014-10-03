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
