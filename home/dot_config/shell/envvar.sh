#! /bin/sh
# shellcheck disable=SC2155 # ignoring as it is a profile script

export XDG_CONFIG_HOME="$HOME/.config"

if command -v hx >/dev/null 2>&1; then
    export EDITOR="hx"
elif command -v vim >/dev/null 2>&1; then
    export EDITOR="vim"
else
    export EDITOR="vi"
fi
