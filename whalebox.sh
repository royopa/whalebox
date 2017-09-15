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

alias terraform='docker run -i --rm -v $(get_home)/.aws:/root/.aws -v $(get_pwd):/wd/ -w /wd/ hashicorp/terraform:light'
alias tflint='docker run -i --rm -v $(get_pwd):/wd/ -w /wd/ wata727/tflint:latest'
alias jq='docker run -i --rm -v $(get_pwd):/wd/ -w /wd/ z0beat/jq'
alias aws='docker run -ti --rm -v $(get_home)/.aws:/root/.aws -v $(get_pwd):/wd/ -w /wd/ z0beat/awscli'