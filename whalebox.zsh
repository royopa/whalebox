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

function build_docker_command {
    image=$1
    echo 'docker run -ti --rm $(get_root_volumes) -v $(get_home):/root/ -v $(get_pwd):/wd/ -w /wd/' $image 
}

typeset -A WHALEBOXES
WHALEBOXES[python2]='python:2-alpine python'
WHALEBOXES[pip2]='python:2-alpine pip'
WHALEBOXES[python3]='python:3-alpine python'
WHALEBOXES[pip3]='python:3-alpine pip'
WHALEBOXES[java6]='openjdk:6-alpine java'
WHALEBOXES[java7]='openjdk:7-alpine java'
WHALEBOXES[java8]='openjdk:8-alpine java'
WHALEBOXES[java9]='openjdk:9-slim java'
WHALEBOXES[mvn7]='maven:3-jdk-7-alpine mvn'
WHALEBOXES[mvn8]='maven:3-jdk-8-alpine mvn'
WHALEBOXES[mvn9]='maven:3-jdk-9-slim mvn'
WHALEBOXES[aws]='z0beat/awscli'
WHALEBOXES[azure]='microsoft/azure-cli:latest azure'
WHALEBOXES[gcloud]='google/cloud-sdk:alpine gcloud'
WHALEBOXES[gsutil]='google/cloud-sdk:alpine gsutil'
WHALEBOXES[bq]='google/cloud-sdk:alpine bq'
WHALEBOXES[terraform]='hashicorp/terraform:light'
WHALEBOXES[tflint]='wata727/tflint:latest'
WHALEBOXES[jq]='z0beat/jq'

for whalebox in "${(@k)WHALEBOXES}"; do
    alias $whalebox="$(build_docker_command $WHALEBOXES[$whalebox])"
done