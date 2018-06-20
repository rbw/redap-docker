#!/usr/bin/env sh

context_file=$(dirname $0)/.context
if [ -f ${context_file} ]; then
    if [ -z ${1} ]; then
        docker --help
    else
        docker ${1} $(cat ${context_file});
    fi
else
    echo "Unable to read .context, cannot determine container"
fi
