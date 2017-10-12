#!/bin/bash

function is_wsl {
    if [[ -e /mnt/c/Windows/System32/cmd.exe ]]; then
        return 0
    else
        return 1
    fi
}

function get_home {
    if is_wsl; then
        echo /c/Users/$(cmd.exe \/C 'echo %USERNAME%' 2> /dev/null | tr -d '[:space:]')
    else
        echo $HOME
    fi
}

function get_pwd {
    if is_wsl; then
        pwd | sed -e 's /mnt/\([a-z]\{1\}\)/ /\1/ '
    else
        pwd
    fi
}

function get_root_volumes {
    if is_wsl; then
        local rootvolumes=""
        for drive in /mnt/*; do
            rootvolumes+="-v /$(basename $drive):$drive "
        done
        echo "$rootvolumes"
    else
        # For convenience, maybe the user wants to make a symlink like this:
        # $ ln -s / /mnt/whalebox
        echo "-v /:/mnt/whalebox"
    fi
}

docker run --rm whalebox > /tmp/whaleboxes.alias
source /tmp/whaleboxes.alias