#!/usr/bin/env sh

readlink_canonicalize() (
    cd "$(dirname "$1")"

    local target_file="$(basename "$1")"

    while [ -L "$target_file" ]; do
        target_file="$(readlink "$target_file")"
        cd "$(dirname "$target_file")"
        target_file="$(basename "$target_file")"
    done

    local phys_dir="$(pwd -P)"
    printf '%s\n' "${phys_dir}/${target_file}"
)

WHO_AM_I="$(which "$0")"
JQ_FILE="$(dirname "$(readlink_canonicalize "$WHO_AM_I")")/sina.jq"

curl -sS 'https://interface.sina.cn/news/wap/fymap2020_data.d.json' | jq -r -f "$JQ_FILE"
