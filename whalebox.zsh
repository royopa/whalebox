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

typeset -A WHALEBOXES
WHALEBOXES[terraform]='docker run -ti --rm $(get_root_volumes) -v $(get_home)/.aws:/root/.aws -v $(get_pwd):/wd/ -w /wd/ hashicorp/terraform:light'
WHALEBOXES[tflint]='docker run -ti --rm $(get_root_volumes) -v $(get_pwd):/wd/ -w /wd/ wata727/tflint:latest'
WHALEBOXES[jq]='docker run -ti --rm $(get_root_volumes) -v $(get_pwd):/wd/ -w /wd/ z0beat/jq'
WHALEBOXES[aws]='docker run -ti --rm $(get_root_volumes) -v $(get_home)/.aws:/root/.aws -v $(get_pwd):/wd/ -w /wd/ z0beat/awscli'

for whalebox in "${(@k)WHALEBOXES}"; do
    alias $whalebox="$WHALEBOXES[$whalebox]"
done